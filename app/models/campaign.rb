class Campaign < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :emails
  
  attr_accessible :name, :intro, :body, :recipients, :tag_list, :image

  validates_presence_of :name, :intro, :body
  validates_uniqueness_of :name

  acts_as_taggable

  mount_uploader :image, CampaignImageUploader

  attr_accessor :recipients

  before_save :generate_slug, :create_recipients

  class << self

    def last_campaigns(limit = nil)
      order("created_at DESC").limit(limit).all
    end
  end

  def to_param
    slug
  end

  def to_html(field)
    markdown = Redcarpet.new(field)
    markdown.to_html
  end


  private

  def generate_slug
    self.slug = self.name.parameterize
  end

  # método para crear registros en la tabla emails
  def create_recipients
    #logger.debug('DEBUG: Lista de destinatarios: ' + recipients.inspect)
    addresses = recipients.gsub(/\s+/, ',').split(',')
    addresses.each {|a| a.downcase! }.uniq!
    addresses.each {|a| emails << Email.create(:address => a) }
  end
end
