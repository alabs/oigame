# encoding: utf-8
class Campaign < ActiveRecord::Base

  belongs_to :user
  belongs_to :sub_oigame
  has_many :messages
  has_many :petitions
  
  attr_accessible :name, :intro, :body, :recipients, :tag_list, :image, :target, :duedate_at, :ttype, :default_message_subject, :default_message_body
  attr_accessor :recipient

#  validate :validate_minimum_image_size
  attr_accessor :image_width, :image_height

  serialize :emails, Array

  TYPES = { :petition => 'Petición online', :mailing => 'Envio de correo' }

  validates :name, :uniqueness => { :scope => :sub_oigame_id }
  validates :name, :image, :intro, :body, :ttype, :duedate_at, :presence => true

  acts_as_taggable

  mount_uploader :image, CampaignImageUploader

  before_save :generate_slug

  # Scope para solo mostrar la campañas que han sido moderadas
  scope :published, where(:moderated => false, :status => 'active')
  scope :not_published, where(:moderated => true, :status => 'active')
  scope :archived, where(:status => 'archived')


  class << self

    def last_campaigns(limit = nil)
      order('priority DESC').order('published_at DESC').published.limit(limit).all
    end

    def last_campaigns_by_tag(tag, limit = nil)
      tagged_with(tag).order('published_at DESC').published.limit(limit).all
    end

    def last_campaigns_by_tag_archived(tag, limit = nil)
      tagged_with(tag).order('published_at DESC').archived.limit(limit).all
    end

    def last_campaigns_moderated
      order('created_at DESC').where('moderated = ?', true).all  
    end

    def archived_campaigns
      order('published_at DESC').archived.all
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

  def recipients
    self.emails.join("\r\n")
  end

  def recipients=(args)
    addresses = args.gsub(/\s+/, ',').split(',')
    addresses.each {|address| address.downcase! }.uniq!
    # FIXME: undefined method `downcase!' for nil:NilClass
    # addresses.each {|address| address.strip!.downcase! }.uniq!
    addresses.delete_if {|a| a.blank? }
    self.emails = addresses
  end
  
  def recipients_for_message
    self.emails.join(',')
  end

  def to_html(field)
    markdown = Redcarpet.new(field)
    markdown.to_html
  end

  def activate!
    self.moderated = false
    self.published_at = Time.now
    save!
    if Rails.env == 'production'
      tweet_campaign
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
    Twitter.update(self.name + ' - ' + "#{APP_CONFIG[:domain]}/campaigns/#{self.slug}")
  end

  # custom validation for image width & height minimum dimensions
  def validate_minimum_image_size
    if self.image_width < 500 && self.image_height < 200
      errors.add :image, "debe tener 500px de ancho y 200px de largo como mínimo" 
    end
  end


end
