class Petition < ActiveRecord::Base

  belongs_to :campaign, :counter_cache => true

  attr_accessible :campaign, :email, :token, :validated, :name, :identity_card, :postal_code, :state

  scope :validated, where(:validated => true)
  
  validates_presence_of :email

  # generar método que valie tu un remitente no puede unirse
  # más de una vez a la campaña
  validates_uniqueness_of :email, :scope => :campaign_id
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  # comentada para cuando refactoricemos
  validates_presence_of :name

  def self.last_petitions
    validated.order('created_at DESC').select('created_at, name, campaign_id, id').limit(10)
  end

  def validate
    update_attributes(:validated => true, :token => nil)
  end

end
