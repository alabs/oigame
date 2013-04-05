# encoding: utf-8
namespace :oigame do
  desc "Guardar mensajes relaciones con oiga.me"
  task(:tweets => :environment) do
    TweetStream::Client.new.follow('217754222') do |status|
      t = Tweet.new(:text => status.text)

      puts "TWITTER msg :" + t.text
    end
  end
end
