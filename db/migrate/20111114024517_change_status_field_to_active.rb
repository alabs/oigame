class ChangeStatusFieldToActive < ActiveRecord::Migration
  def up
    Campaign.all.each do |campaign|
      campaign.status = 'active'
      campaign.save
    end
  end

  def down
    Campaign.all.each do |campaign|
      campaign.status = nil
      campaign.save
    end
  end
end
