namespace :cleanup do
  desc "removes stale and inactive campaigns from the database"
  task :campaigns => :environment do
    stale_campaigns = Campaign.where("DATE(created_at) < DATE(?)", Date.yesterday).where("wstatus is not 'active'")
    stale_campaigns.map(&:destroy)
  end
end
