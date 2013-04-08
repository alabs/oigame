# encoding: utf-8

class Campaign < ActiveRecord::Base

  self.per_page = 6

  acts_as_paranoid

  belongs_to :user, :counter_cache => true
  belongs_to :sub_oigame, :counter_cache => true
  has_many :messages
  has_many :petitions
  has_many :faxes, :class_name => 'Fax'
  belongs_to :category
  has_many :donations
  has_many :updates

  attr_accessible :name, :intro, :body, :recipients, :faxes_recipients, :image, :target, :duedate_at, :ttype,
    :default_message_subject, :default_message_body, :commentable, :category_id, :wstatus, :postal_code,
    :identity_card, :state, :ht, :video_url

  attr_accessor :recipient
  attr_accessor :ht

  #validate :validate_minimum_image_size
  attr_accessor :image_width, :image_height

  serialize :emails, Array
  serialize :numbers, Array

  TYPES = {
    :petition =>
    {
      :name       => I18n.t('petition'),
      :img        => 'icon-pencil',
      :model_name => 'Petition',
      :message    => I18n.t('oigame.campaigns.type.petition_message'),
      :action     => I18n.t('oigame.campaigns.type.petition_action'),
    },
    :mailing =>
    {
      :name       => I18n.t('mailing'),
      :img        => 'icon-envelope',
      :model_name => 'Message',
      :message    => I18n.t('oigame.campaigns.type.mailing_message'),
      :action     => I18n.t('oigame.campaigns.type.mailing_action'),
    },
    :fax =>
    {
      :name       => I18n.t('fax'),
      :img        => 'icon-print',
      :model_name => 'Fax',
      :message    => I18n.t('oigame.campaigns.type.fax_message'),
      :action     => I18n.t('oigame.campaigns.type.fax_action'),
    },
  }
  # { :petition => 'Petición online', :mailing => 'Envio de correo', :fax => 'Envio de fax' }

  STATUS = %w[active archived deleted]

  validates_presence_of :name
  validates :name, :uniqueness => { :scope => :sub_oigame_id }
  validates_presence_of :image, :if => :active_or_image?
  validates_presence_of :intro, :if => :active_or_intro?
  validates_presence_of :body,  :if => :active_or_body?
  validates_presence_of :ttype,  :if => :active_or_ttype?
  validates_presence_of :duedate_at, :if => :active_or_duedate_at?
  validates :intro, :length => { :maximum => 500 }
  validates :default_message_body, :length => { :maximum => 3960 }, :if => :fax_campaign?

  validate :validate_video_url_provider

  mount_uploader :image, CampaignImageUploader

  before_save :generate_slug
  before_save :normalize_target

  # Scope para solo mostrar la campañas que han sido moderadas
  scope :published, where(:moderated => false, :status => 'active').order('priority DESC')
  scope :not_published, where(:moderated => true, :status => 'active').where('wstatus != ?', 'active')
  scope :on_archive, where(:status => 'archived', :wstatus => 'active')
  scope :_archived, where(:status => 'archived', :wstatus => 'active')
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
      where(:sub_oigame_id => sub_oigame).where(:wstatus => 'active').order('created_at DESC').where('moderated = ?', true).page(page)  
    end

    def last_campaigns_moderated_without_pagination(sub_oigame = nil)
      where(:sub_oigame_id => sub_oigame).where(:wstatus => 'active').order('created_at DESC').where('moderated = ?', true)
    end

    def archived_campaigns(page = 1, sub_oigame = nil)
      where(:sub_oigame_id => sub_oigame).where(:wstatus => 'active').order('published_at DESC').on_archive.page(page)
    end

    def archived_campaigns_without_pagination(sub_oigame = nil)
      where(:sub_oigame_id => sub_oigame).where(:wstatus => 'active').order('published_at DESC').on_archive
    end

    def total_published_campaigns
      where("published_at IS NOT NULL")
    end

    def types
      TYPES
    end
  end

  def to_s
    self.name
  end

  def has_credit?(credits)
    (self.credit - credits) >= 0
  end

  def generate_file_with_numbers_for_faxing(fax_id)
    numbers = self.numbers
    fh = File.open("/tmp/numbers-#{fax_id}-#{self.id}.txt", "w+")
    numbers.each {|n| fh.print(n + "\r\n")}
    fh.close
    return fh.path
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
    return self.petitions + self.messages + self.faxes
  end

  def faxes_recipients
    self.numbers.join("\r\n")
  end

  def faxes_recipients=(args)
    numbs = args.gsub(/\s+/, ',').split(',')
    # arreglar el bug del strip
    # numbs.each {|number| number.strip!.downcase! }.uniq!
    numbs.each {|number| number.downcase! }.uniq!
    numbs.delete_if {|n| n.blank? }
    self.numbers = numbs
  end

  def recipients
    self.emails.join("\r\n")
  end

  def recipients_list
    case ttype
    when 'mailing'
      emails.join("\r\n").gsub('@','[arroba]')
    when 'petition'
      emails.join("\r\n").gsub('@','[arroba]')
    when 'fax'
      faxes_recipients
    end
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

  def normalize_target
    self.target = self.target.gsub(/\./, '') unless self.target.blank?
  end

  def to_html(field)
    render = Redcarpet::Render::HTML.new(:filter_html => true)
    markdown = Redcarpet::Markdown.new(render,
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
    Mailman.inform_campaign_activated(self.id).deliver
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

  def ttype_message
    Campaign::TYPES[ttype.to_sym][:message]
  end

  def ttype_action
    Campaign::TYPES[ttype.to_sym][:action]
  end

  def ttype_img
    Campaign::TYPES[ttype.to_sym][:img]
  end

  def ttype_name
    Campaign::TYPES[ttype.to_sym][:name]
  end

  def ttype_model_name
    Campaign::TYPES[ttype.to_sym][:model_name]
  end

  def archived?
    status == "archived"
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
      return Campaign.published.order('priority ASC').find(:all, :conditions => ["id != ?", self.id], :limit => 6)
    else
      return Campaign.published.order('priority ASC').find(:all, :conditions => ["id != ? and sub_oigame_id = ?", self.id, self.sub_oigame.id], :limit => 6)
    end
  end

  def get_absolute_url
    if sub_oigame.nil?
      return APP_CONFIG[:domain] + "/campaigns/" + slug
    else 
      return APP_CONFIG[:domain] + "/o/" + sub_oigame.name + "/campaigns/" + slug
    end
  end

  def get_image_absolute_url
    return APP_CONFIG[:domain] + image_url
  end

  def stats
    case ttype
    when "petition"
      model = Petition
      file_name = "petition"
    when "mailing"
      model = Message
      file_name = "message"
    when "fax"
      model = Fax
      file_name = "fax"
    end
    dates = (created_at.to_date..Date.today).map{ |date| date.to_date }
    data = []
    counter = 0
    require Rails.root.to_s+'/app/models/'+file_name
    dates.each do |date|
      count = Rails.cache.fetch("s4#{ttype}_#{id}_#{date.to_s}", :expires_in => 3.hour) { model.validated.where("created_at BETWEEN ? AND ?", date, date.tomorrow.to_date).where(:campaign_id => id).all }.count
      counter += count
      data.push([date.strftime('%Y-%m-%d'), counter])
    end

    return data
  end

  def has_participated?(user_or_email)
    # comprobamos si este usuario ya ha participado en este campaña
    # puede ser una instnacia de un usuario o un mail solo en texto

    participants_emails = self.participants.map {|x| x.email}

    # si es un usuario, ejemplo current_user
    if defined? user_or_email.email
      return participants_emails.include? user_or_email.email
    end

    # si es un mail solo
    if user_or_email and user_or_email.include? "@"
      return participants_emails.include? user_or_email
    end
    
  end

  def active?
    wstatus == 'active'
  end

  def active_or_image?
    wstatus.include?('image') || active?
  end

  def active_or_intro?
    wstatus.include?('intro') || active?
  end

  def active_or_body?
    wstatus.include?('body') || active?
  end

  def active_or_ttype?
    wstatus.include?('ttype') || active?
  end

  def active_or_duedate_at?
    wstatus.include?('duedate_at') || active?
  end

  def obj_minus_gotten_result
    target.to_i - participants_count 
  end

  def messages_count
    recipients_count * participants_count
  end

  def recipients_count
    case ttype
    when 'mailing'
      emails.count
    when 'petition'
      1 # o sino multiplicamos por 0 y explota todo
    when 'fax'
      faxes_recipients.split(/\r\n/).count
    end
  end

  def participants_count
    case ttype
    when 'mailing'
      messages.validated.count.to_i
    when 'petition'
      petitions.validated.count.to_i
    when 'fax'
      faxes.validated.count.to_i
    end
  end

  def participants_list
    case ttype
    when 'mailing'
      model = messages
    when 'petition'
      model = petitions
    when 'fax'
      model = faxes
    end

    recipients = model.map {|m| m.email}.sort.uniq
    response = ""
    recipients.each {|r| response += r + "\n" }
    return response
  end

  # for twitter hashtag
  def ht=(args)
    str = args
    str = str.gsub(/#/, '').gsub(/,/, '')
    self.hashtag = str.split.first
  end

  def facebook_it
    oauth = Koala::Facebook::OAuth.new(APP_CONFIG[:FACEBOOK_APP_ID], APP_CONFIG[:FACEBOOK_SECRET])
    token = oauth.get_app_access_token
    page_graph = Koala::Facebook::API.new(token)
    logger.debug('DEBUG: ' + page_graph.inspect)
    #page_graph.put_connections(APP_CONFIG[:FACEBOOK_APP_ID], 'feed', :link => self.get_absolute_url)
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
    if self.hashtag
      Twitter.update(self.name[0,100] + ' - ' + get_absolute_url + ' - ' + "#"+self.hashtag)
    else
      Twitter.update(self.name + ' - ' + get_absolute_url)
    end
  end

  # custom validation for image width & height minimum dimensions
  def validate_minimum_image_size
    if self.image_width < 500 && self.image_height < 200
      errors.add :image, "debe tener 500px de ancho y 200px de largo como mínimo" 
    end
  end

  def validate_video_url_provider
    if !self.video_url.blank?
      unless self.video_url.start_with?("http://youtu.be/", "http://www.youtube.com/watch?v=", "https://www.youtube.com/watch?v=", "http://vimeo.com/")
        errors.add :video_url, "must be a valid provider" 
      end
    end
  end

  def fax_campaign?
    self.ttype == 'fax'
  end
end

