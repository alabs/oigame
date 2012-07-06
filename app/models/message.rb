class Message < ActiveRecord::Base

  belongs_to :campaign, :counter_cache => true

  attr_accessible :campaign, :email, :subject, :body, :token, :validated

  scope :validated, where(:validated => true)

  # generar método que valide que un remitente no puede enviar
  # más de un mensaje por campaña
  validates_uniqueness_of :email, :scope => :campaign_id
end
