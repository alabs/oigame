class Message < ActiveRecord::Base

  belongs_to :campaign

  attr_accessible :campaign, :email

  # generar método que valide que un remitente no puede enviar
  # más de un mensaje por campaña
end
