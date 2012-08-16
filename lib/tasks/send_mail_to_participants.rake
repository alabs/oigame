# encoding: utf-8
namespace :oigame do
  desc "Enviar mensaje a los participantes de una campaña"
  task(:mailing_for_participants => :environment) do
    message = File.open(ENV['FILENAME'], 'r').read
    subject = ENV['SUBJECT']
    campaign_id = ENV['CAMPAIGN_ID']
    
    petitions = Petition.where(:campaign_id => campaign_id, :validated => true).all
    emails = []
    petitions.each do |p|
      emails << p.email
    end

    i = 1
    emails.each do |email|
      Mailman.send_mailing(email, subject, message).deliver
      puts "Mensaje #{i} enviado"
      i += 1
    end
  end
end
