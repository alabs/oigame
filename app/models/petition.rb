class Petition < ActiveRecord::Base

  belongs_to :campaign

  attr_accessible :campaign, :email, :token, :validated

  scope :validated, where(:validated => true)

  # generar método que valie tu un remitente no puede unirse
  # más de una vez a la campaña
end
