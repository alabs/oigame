class MigrationwStatusSetActive < ActiveRecord::Migration
  def up
    campaigns = Campaign.published.all
    campaigns.each do |c|
      c.wstatus = 'active'
      c.save
    end
  end

  def down
    campaigns = Campaign.published.all
    campaigns.each do |c|
      c.wstatus = nil
      c.save
    end
  end
end
