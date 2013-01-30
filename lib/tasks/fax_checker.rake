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

    Mail.all.each do |m|
      begin
        status = OVHFaxChecker.status m
      rescue Net::POPAuthenticationError
        raise "-ERR Authentication failed."
      end
      #puts status
      fax = Fax.find status[:fax_id]
      if fax.check_date.nil? or Time.at(status[:date]).to_datetime > fax.check_date 
        puts "processing" 
        fax.check_date = Time.at(status[:date]).to_datetime
        fax.check_message = status[:message]
        fax.check_ticket_id = status[:ticket_id]
        fax.save
      end
    end
    #Mail.delete_all

  end
end

