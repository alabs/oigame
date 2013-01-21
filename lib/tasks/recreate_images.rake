# encoding: utf-8

namespace :oigame do
  desc "Recrear thumbnails de imagenes de Campaign de CarrierWave"
  task(:recreate_images => :environment) do
    Campaign.all.each {|c| c.image.recreate_images}
  end
end


