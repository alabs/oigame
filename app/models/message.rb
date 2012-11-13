class Message < ActiveRecord::Base

  belongs_to :campaign, :counter_cache => true

  attr_accessible :campaign, :email, :subject, :body, :token, :validated, :name

  scope :validated, where(:validated => true)

  validates_presence_of :email

  # generar método que valide que un remitente no puede enviar
  # más de un mensaje por campaña
  validates_uniqueness_of :email, :scope => :campaign_id
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validates_presence_of :name
end
