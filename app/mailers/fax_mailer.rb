class FaxMailer < ActionMailer::Base

  include Resque::Mailer # para enviar correos en background
  
  default from: "faxbox@oiga.me"

  def send_fax(number)
    number = number.to_s.prepend('00')
  end
end
