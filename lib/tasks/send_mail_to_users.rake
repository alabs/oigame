namespace :oigame do
  desc "Enviar mailing a usuarios"
  task(:mailing => :environment) do
    message = File.open(ENV['FILENAME'], 'r').read
    subject = ENV['SUBJECT']

    i = 1
    User.get_mailing_users.each do |user|
      Mailman.send_mailing(user.email, subject, message).deliver
      puts "Mensaje #{i} enviado"
      i += 1
    end
  end
end
