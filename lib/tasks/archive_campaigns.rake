# encoding: utf-8
namespace :oigame do
  desc "Archivar campañas pasadas"
  task(:archive_campaigns => :environment) do
    Campaign.published.where("duedate_at <= ?", Time.now).all.each do |campaign|
      campaign.archive
    end
  end
end
