class Campaign < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :emails
  
  attr_accessible :name, :intro, :body, :recipients, :tag_list, :image

  validates_presence_of :name, :intro, :body
  validates_uniqueness_of :name

  acts_as_taggable

  mount_uploader :image, CampaignImageUploader

  attr_accessor :recipients

  before_save :create_recipients

  def self.last_campaigns(limit = nil)
    order("created_at DESC").limit(limit).all
  end

  def to_html(field)
    markdown = Redcarpet.new(field)
    markdown.to_html
  end

  private

  # método para crear registros en la tabla emails
  def create_recipients
    #logger.debug('DEBUG: Lista de destinatarios: ' + recipients.inspect)
    addresses = recipients.gsub(/\s+/, ',').split(',')
    addresses.each {|a| a.downcase! }.uniq!
    addresses.each {|a| emails << Email.create(:address => a) }
  end
end
