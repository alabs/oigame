# encoding: utf-8
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
      status = OVHFaxChecker.get_status m
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

require 'mail'

class OVHFaxChecker
  # Procesa trabajos de FAX de oiga.me.
  # 
  # ESTADOS
  # 100 - enviado         - "Envío de 'fax-1-1.pdf'  hacia 00442035146769 añadido en lista de espera"
  # 200 - recibido        - "fax 'fax-1-1.pdf' a 00442035146769 se ha cumpletado"
  # 500 - error           - "fax 'fax-1-1.pdf' a 0034917405210 falló"
  # 500 - error           - "fax 'fax-1-1.pdf' a 00442035146769 ha sido puesto em memoria"
  # 000 - desconocido  :S - ????????????????

  def self._get_fax_id mail
    mail.subject.split(/'/)[1].split(/\./)[0].split(/-/)[2].to_i
  end

  def self._get_campaign_id mail
    mail.subject.split(/'/)[1].split(/\./)[0].split(/-/)[1].to_i
  end

  def self._splitter(mail, line_number, key_string)
    mail.body.decoded.split(/\n/)[line_number].strip.split(key_string)[1]
  end

  def self._get_date mail
    mail.date.to_time.to_i
  end

  def self.get_status mail
    # Devuelve un diccionario con el estado del mail
    # mail es un objeto que devuelve la libreria mail
    #
    # Ejemplos:
    #     {:fax_id=>14, :campaign_id=>24, :date=>1354793856, :message=>"Processing", :code=>100, :ticket_id=>23590253}
    #     {:fax_id=>14, :campaign_id=>24, :date=>1354793918, :message=>"Busy signal detected=20", :code=>500, :ticket_id=>23590253}
    #     {:fax_id=>14, :campaign_id=>24, :date=>1354794996, :message=>"Busy signal detected ; too many attempts to dia=", :code=>500, :ticket_id=>23590253}

    status = {
      :fax_id      => OVHFaxChecker._get_fax_id(mail),
      :campaign_id => OVHFaxChecker._get_campaign_id(mail),
      :date        => OVHFaxChecker._get_date(mail),
      :message     => nil,
    }
    case mail.subject
      when /añadido en lista de espera/
        status[:code]      = 100
        status[:ticket_id] = OVHFaxChecker._splitter(mail, 4, " es el ").to_i
        status[:message]   = "Processing"
      when /se ha cumpletado/
        status[:code]      = 200
        status[:ticket_id] = OVHFaxChecker._splitter(mail, 22, 'IDTrabajo: ').to_i
      when /(ha sido puesto em memoria|falló)/
        # Puede venir en distintas lineas, hay que tratarlas todas
        error_mes1 = OVHFaxChecker._splitter(mail, 24, 'Estado: ')
        error_mes2 = OVHFaxChecker._splitter(mail, 25, 'Estado: ')
        error_mes3 = OVHFaxChecker._splitter(mail, 26, 'Estado: ')
        ticket_id1 = OVHFaxChecker._splitter(mail, 27, 'IDTrabajo: ').to_i
        ticket_id2 = OVHFaxChecker._splitter(mail, 28, 'IDTrabajo: ').to_i
        status[:code]      = 500
        status[:ticket_id] = ticket_id1 == 0 ? ticket_id2 : ticket_id1
        status[:message]   = error_mes1 ? error_mes1 : ( error_mes2 ? error_mes2 : error_mes3 )
      else
        status[:code]      = 000
        status[:message]   = "Unknown"
    end
    return status
  end

end
