# encoding: utf-8

namespace :oigame do
  desc "Validación: recordatorio entre 3 y 7 días sin validar."
  task(:revalidate_messages => :environment) do

    messages = []
    [Message, Petition, Fax].each do |mod|
      messages.concat( mod
        .where(:validated => false)
        .where('created_at < ?', 3.days.ago)
        .where('created_at > ?', 31.days.ago)
        .where(:revalidate_counter => nil)
        .where("token IS NOT NULL")
      )
    end

    messages.each do |m|
      # utilizamos el contador de revalidaciones para no spamear a los usuarios
      # con la validacion del mismo mensaje
      m.revalidate_counter = 1
      m.save
      model_name = Campaign.types[m.campaign.ttype.to_sym][:model_name]
      validation = "send_message_to_validate_#{model_name.downcase}".to_s
      Mailman.send(validation, m.email, m.campaign.id, m.id).deliver
    end

  end

end
