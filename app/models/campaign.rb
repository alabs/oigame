# encoding: utf-8
class Campaign < ActiveRecord::Base


  self.per_page = 5

  acts_as_paranoid

  belongs_to :user, :counter_cache => true
  belongs_to :sub_oigame, :counter_cache => true
  has_many :messages
  has_many :petitions
  
  attr_accessible :name, :intro, :body, :recipients, :image, :target, :duedate_at, :ttype, :default_message_subject, :default_message_body, :commentable
  attr_accessor :recipient

#  validate :validate_minimum_image_size
  attr_accessor :image_width, :image_height

  serialize :emails, Array

  TYPES = { :petition => 'Petición online', :mailing => 'Envio de correo' }
  STATUS = %w[active archived deleted]

  validates :name, :uniqueness => { :scope => :sub_oigame_id }
  validates :name, :image, :intro, :body, :ttype, :duedate_at, :presence => true
  # validación desactivada porque genera excepción al manipular objetos
  # antiguos que tienen una intro de mas de 500 caracteres
  #validates :intro, :length => { :maximum => 500 }

  mount_uploader :image, CampaignImageUploader

  before_save :generate_slug

  # Scope para solo mostrar la campañas que han sido moderadas
  scope :published, where(:moderated => false, :status => 'active')
  scope :on_archive, where(:status => 'archived')
  scope :_archived, where(:status => 'archived')
  scope :not_published, where(:moderated => true, :status => 'active')
  scope :by_sub_oigame, lambda {|sub| where(:sub_oigame_id => sub) unless sub.nil? }

  # thinking sphinx
  define_index do
    # fields
    indexes :name, :sortable => true
    indexes :intro
    indexes :status
    indexes :sub_oigame_id
    
    # a little hack para que podamos buscar por nil
    # https://groups.google.com/forum/?fromgroups#!topic/thinking-sphinx/CUwd3m_4cLQ
    has "sub_oigame_id IS NULL", :type => :boolean, :as => :no_sub

    # attributes
    #has sub_oigame_id, moderated, created_at, updated_at
    has moderated, created_at, updated_at
  end

  sphinx_scope(:active) {
    { :with  =>  { :moderated => false } }
  }


  class << self

    # Estudiar esta query para que no haga un MySQL filesort
    def last_campaigns(page = 1, sub_oigame = nil, limit = nil)
      includes(:messages, :petitions).order('priority DESC').order('published_at DESC').where(:sub_oigame_id => sub_oigame).published.limit(limit).page(page)
    end
    
    def last_campaigns_without_pagination(limit = nil)
      includes(:messages, :petitions).order('priority DESC').order('published_at DESC').where(:sub_oigame_id => nil).published.limit(limit)
    end

    def last_campaigns_moderated(page = 1, sub_oigame = nil)
      where(:sub_oigame_id => sub_oigame).order('created_at DESC').where('moderated = ?', true).page(page)  
    end

    def archived_campaigns(page = 1, sub_oigame = nil)
      where(:sub_oigame_id => sub_oigame).order('published_at DESC').on_archive.page(page)
    end
  end

  # Para repartir el envio de mensajes en varios enlaces
  def partition_of_emails(size = 60)
    data = []
    emails.in_groups_of(size, false).each_with_index do |group, i|
      data[i] = group.join(',')
    end

    return data
  end

  def to_param
    slug
  end

  def participants
    petitions = self.petitions
    mailings = self.messages

    data = petitions + mailings
    data = data.collect { data.slice!(rand data.length) }

    return data[0,27]
  end

  def recipients
    self.emails.join("\r\n")
  end

  def recipients=(args)
    addresses = args.gsub(/\s+/, ',').split(',')
    # arreglar el bug del strip
    # addresses.each {|address| address.strip!.downcase! }.uniq!
    addresses.each {|address| address.downcase! }.uniq!
    addresses.delete_if {|a| a.blank? }
    self.emails = addresses
  end
  
  def recipients_for_message
    self.emails.join(',')
  end

  def to_html(field)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      :autolink => true, :space_after_headers => true)
    markdown.render(field).html_safe
  end

  def activate!
    self.moderated = false
    self.status = 'active'
    self.published_at = Time.now
    save!
    if Rails.env == 'production'
      tweet_campaign
      # ha empezado a dar error
      # facebook_it
    end
    Mailman.inform_campaign_activated(self).deliver
  end

  def deactivate!
    self.moderated = true
    save!
  end

  def moderated?
    moderated == true ? true : false
  end

  def published?
    moderated == false ? true : false
  end

  def stats
  end

  def archive
    self.status = 'archived'
    save!
  end

  def trash
    self.status = 'deleted'
    save!
  end

  def other_campaigns
    # devuelve otras campaigns similares a la que estamos seleccionando, quitando la que usamos
    # tiene en cuenta el sub
    if self.sub_oigame.nil?
      return Campaign.published.order('priority DESC').find(:all, :conditions => ["id != ?", self.id], :limit => 5)
    else
      return Campaign.published.order('priority DESC').find(:all, :conditions => ["id != ? and sub_oigame_id = ?", self.id, self.sub_oigame.id], :limit => 5)
    end
  end

  def get_absolute_url
    if self.sub_oigame.nil?
      return APP_CONFIG[:domain] + "/campaigns/" + self.slug
    else 
      return APP_CONFIG[:domain] + "/o/" + self.sub_oigame.name + "/campaigns/" + self.slug
    end
  end

  def stats_for_mailing(campaign)
    dates = (campaign.created_at.to_date..Date.today).map{ |date| date.to_date }
    data = []
    messages = 0
    require Rails.root.to_s+'/app/models/message'
    dates.each do |date|
      count = Rails.cache.fetch("s4m_#{campaign.id}_#{date.to_s}", :expires_in => 3.hour) { Message.validated.where("created_at BETWEEN ? AND ?", date, date.tomorrow.to_date).where(:campaign_id => campaign.id).all }.count
      messages += count
      data.push([date.strftime('%Y-%m-%d'), messages])
    end
    
    return data
  end
  
  def stats_for_petition(campaign)
    dates = (campaign.created_at.to_date..Date.today).map{ |date| date.to_date }
    data = []
    petitions = 0
    require Rails.root.to_s+'/app/models/petition'
    dates.each do |date|
      count = Rails.cache.fetch("s4p_#{campaign.id}_#{date.to_s}", :expires_in => 3.hour) { Petition.validated.where("created_at BETWEEN ? AND ?", date, date.tomorrow.to_date).where(:campaign_id => campaign.id).all }.count
      petitions += count
      data.push([date.strftime('%Y-%m-%d'), petitions])
    end
    
    return data
  end

  def has_participated?(user)
    # comprobamos si este usuario ya ha participado en este campaña
    if defined? user.email
      participants_emails = self.participants.map {|x| x.email}
      if participants_emails.include? user.email
        return true
      else
        return false
      end
    end
  end

  private

  def generate_slug
    self.slug = self.name.parameterize
  end

  def tweet_campaign
    Twitter.configure do |config|
      config.consumer_key = APP_CONFIG[:twitter_consumer_key]
      config.consumer_secret = APP_CONFIG[:twitter_consumer_secret]
      config.oauth_token = APP_CONFIG[:twitter_oauth_token]
      config.oauth_token_secret = APP_CONFIG[:twitter_oauth_token_secret]
    end
    Twitter.update(self.name + ' - ' + get_absolute_url)
  end

  def facebook_it
    pages = FbGraph::User.me(APP_CONFIG[:facebook_token]).accounts
    page = []
    pages.each do |p|
      page << p if p.name == 'oiga.me'
    end
    page = page[0]

    page.feed!(
      :message => self.name,
      :link => get_absolute_url,
      :description => self.intro[0..280]
    )
  end

  # custom validation for image width & height minimum dimensions
  def validate_minimum_image_size
    if self.image_width < 500 && self.image_height < 200
      errors.add :image, "debe tener 500px de ancho y 200px de largo como mínimo" 
    end
  end


end
