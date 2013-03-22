class Fax < ActiveRecord::Base

  attr_accessible :campaign, :email, :name, :token, :validated, :body, :identity_card, :postal_code, :state

  belongs_to :campaign, :counter_cache => true

  scope :validated, where(:validated => true)

  validates_presence_of :email
  # generar método que valie tu un remitente no puede unirse
  # más de una vez a la campaña
  validates_uniqueness_of :email, :scope => :campaign_id
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  # comentada para cuando refactoricemos
  validates_presence_of :name
  validates :body, :length => { :maximum => 3960 }

  def self.last_faxes
    validated.order('created_at DESC').select('created_at, name, campaign_id, id').limit(10)
  end

  def validate!
    update_attributes(:validated => true, :token => nil)
    Resque.enqueue(SendFax, self.id)
  end

  def to_s
    self.campaign.name + ": " + self.email
  end
end
