class Campaign < ActiveRecord::Base

  belongs_to :user
  
  attr_accessible :name, :intro, :body, :recipients, :tag_list, :image, :target
  attr_accessor :recipients

  serialize :emails, Array

  validates_presence_of :name, :intro, :body
  validates_uniqueness_of :name

  acts_as_taggable

  mount_uploader :image, CampaignImageUploader

  before_save :generate_slug

  # Scope para solo mostrar la campañas que han sido moderadas
  scope :published, where(:moderated => false)
  scope :not_published, where(:moderated => true)

  class << self

    def last_campaigns(limit = nil)
      order('created_at DESC').published.limit(limit).all
    end

    def last_campaigns_by_tag(tag, limit = nil)
      tagged_with(tag).order('created_at DESC').published.limit(limit).all
    end

    def last_campaigns_moderated
      order('created_at ASC').where('moderated = ?', true).all  
    end
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
    # Descomentar cuando pasemos a producción
    #if Rails.env == 'production'
    #  tweet_campaign
    #end
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
    Twitter.update(self.name + ' - ' + "http://#{APP_CONFIG[:domain]}/campaigns/#{self.slug}")
  end
end
