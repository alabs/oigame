# encoding: utf-8
namespace :oigame do
  desc "Guardar mensajes relaciones con oiga.me"
  task(:tweets => :environment) do
    TweetStream::Client.new.track('oigame', 'oiga.me') do |status|
      Tweet.create(:msg => status.text)
    end
  end
end
