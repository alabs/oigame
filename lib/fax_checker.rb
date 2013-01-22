# encoding: utf-8

class OVHFaxChecker

  # Acepta objetos de mail 

    # Devuelve un diccionario con el estado del mail. mail es un objeto que devuelve la
    # libreria mail, con sus metodos (mail.body.decoded, mail.date, mail.subject)

    #
    # Ejemplos:
    #     {:fax_id=>14, :campaign_id=>24, :date=>1354793856, :message=>"Processing", :code=>100, :ticket_id=>23590253}
    #     {:fax_id=>14, :campaign_id=>24, :date=>1354793918, :message=>"Busy signal detected=20", :code=>500, :ticket_id=>23590253}
    #     {:fax_id=>14, :campaign_id=>24, :date=>1354794996, :message=>"Busy signal detected ; too many attempts to dia=", :code=>500, :ticket_id=>23590253}


  # Procesa trabajos de FAX de oiga.me.
  # 
  # ESTADOS
  # 100 - enviado         - "Envío de 'fax-1-1.pdf'  hacia 00442035146769 añadido en lista de espera"
  # 200 - recibido        - "fax 'fax-1-1.pdf' a 00442035146769 se ha cumpletado"
  # 500 - error           - "fax 'fax-1-1.pdf' a 0034917405210 falló"
  # 500 - error           - "fax 'fax-1-1.pdf' a 00442035146769 ha sido puesto em memoria"
  # 000 - desconocido  :S - ????????????????

  def self.fax_id mail
    mail.subject.split(/'/)[1].split(/\./)[0].split(/-/)[2].to_i
  end

  def self.campaign_id mail
    mail.subject.split(/'/)[1].split(/\./)[0].split(/-/)[1].to_i
  end

  def self.splitter(mail, line_number, key_string)
    mail.body.decoded.split(/\n/)[line_number].strip.split(key_string)[1]
  end

  def self.date mail
    mail.date.to_time.to_i
  end

  def self.status mail
    puts mail.subject
    status = {
      :fax_id      => OVHFaxChecker.fax_id(mail),
      :campaign_id => OVHFaxChecker.campaign_id(mail),
      :date        => OVHFaxChecker.date(mail),
      :message     => nil,
    }
    case mail.subject
      when /añadido en lista de espera/
        status[:code]      = 100
        status[:ticket_id] = OVHFaxChecker.splitter(mail, 4, " es el ").to_i
        status[:message]   = "Processing"
      when /se ha cumpletado/
        status[:code]      = 200
        status[:ticket_id] = OVHFaxChecker.splitter(mail, 22, 'IDTrabajo: ').to_i
      when /(ha sido puesto em memoria|falló)/
        # Puede venir en distintas lineas, hay que tratarlas todas
        error_mes1 = OVHFaxChecker.splitter(mail, 24, 'Estado: ')
        error_mes2 = OVHFaxChecker.splitter(mail, 25, 'Estado: ')
        error_mes3 = OVHFaxChecker.splitter(mail, 26, 'Estado: ')
        ticket_id1 = OVHFaxChecker.splitter(mail, 27, 'IDTrabajo: ').to_i
        ticket_id2 = OVHFaxChecker.splitter(mail, 28, 'IDTrabajo: ').to_i
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
