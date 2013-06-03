# encoding: utf-8

require 'mail'

require 'fax_checker'

namespace :oigame do
  desc "Procesar trabajos de FAX - comprobacion"
  task(:fax_checker => :environment) do

    Mail.defaults do
      retriever_method :pop3,
        :address    => APP_CONFIG[:fax_email_address],
        :port       => APP_CONFIG[:fax_email_port],
        :user_name  => APP_CONFIG[:fax_email_user_name],
        :password   => APP_CONFIG[:fax_email_password],
        :enable_ssl => true
    end

    #TODO: por defecto borra los mensajes que encuentre
    #Mail.find_and_delete do |m|
    Mail.all do |m|
      begin
	ofc = OVHFaxChecker.new(m)
        status = ofc.status
      rescue Net::POPAuthenticationError
        raise "-ERR Authentication failed."
      end
      begin 
        #puts status
        fax = Fax.find status[:fax_id]
        if fax.check_date.nil? or Time.at(status[:date]).to_datetime > fax.check_date 
          fax.check_date = Time.at(status[:date]).to_datetime
          fax.check_message = status[:message]
          fax.check_ticket_id = status[:ticket_id]
          fax.check_code = status[:code]
          fax.save
          # si el fax falla le devolvemos el credito a la campaign
          if fax.check_code == 500 
            camp = Campaign.find status[:campaign_id]
            camp.credit += 1 
            camp.save
          end
        end
      rescue
        # si hay error no borramos el mensaje
        m.skip_deletion = true
        puts "Not valid mail format for #{m.subject}"
      end
    end

  end
end

