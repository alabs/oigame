class Campaign < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :emails
  
  attr_accessible :name, :intro, :body, :recipients, :tag_list

  validates_presence_of :name, :intro, :body
  validates_uniqueness_of :name

  acts_as_taggable

  attr_accessor :recipients

  before_save :create_recipients


  private

  # método para crear registros en la tabla emails
  def create_recipients
    #logger.debug('DEBUG: Lista de destinatarios: ' + recipients.inspect)
    addresses = recipients.gsub(/\s+/, ',').split(',')
    addresses.each {|a| a.downcase! }.uniq!
    addresses.each {|a| emails << Email.create(:address => a) }
  end
end
