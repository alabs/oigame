class Fax < ActiveRecord::Base

  attr_accessible :campaign, :email, :name, :token, :validated, :body

  belongs_to :campaign, :counter_cache => true

  scope :validated, where(:validated => true)

  validates_presence_of :email
  # generar método que valie tu un remitente no puede unirse
  # más de una vez a la campaña
  validates_uniqueness_of :email, :scope => :campaign_id
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validates_presence_of :name
end
