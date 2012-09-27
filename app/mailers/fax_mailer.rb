class FaxMailer < ActionMailer::Base
  
  default from: "faxbox@oiga.me"

  def send_fax(number)
    number = number.to_s.prepend('00')
  end
end
