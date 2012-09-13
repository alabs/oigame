class Petition < ActiveRecord::Base

  belongs_to :campaign, :counter_cache => true

  attr_accessible :campaign, :email, :token, :validated, :name

  scope :validated, where(:validated => true)
  
  validates_presence_of :email

  # generar método que valie tu un remitente no puede unirse
  # más de una vez a la campaña
  validates_uniqueness_of :email, :scope => :campaign_id
end
