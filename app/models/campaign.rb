class Campaign < ActiveRecord::Base

  belongs_to :user
  
  attr_accessible :name, :intro, :body, :recipients, :tag_list, :image

  serialize :emails, Array

  validates_presence_of :name, :intro, :body
  validates_uniqueness_of :name

  acts_as_taggable

  mount_uploader :image, CampaignImageUploader

  before_save :generate_slug

  class << self

    def last_campaigns(limit = nil)
      order("created_at DESC").limit(limit).all
    end

    def last_campaigns_by_tag(tag, limit = nil)
      tagged_with(tag).order("created_at DESC").limit(limit).all
    end
  end

  def to_param
    slug
  end

  def emails=
    emails = emails.gsub(/\s+/, ',').split(',')
    emails.each {|address| address.downcase! }.uniq!
    self.emails = emails
  end

  def to_html(field)
    markdown = Redcarpet.new(field)
    markdown.to_html
  end

  private

  def generate_slug
    self.slug = self.name.parameterize
  end
end
