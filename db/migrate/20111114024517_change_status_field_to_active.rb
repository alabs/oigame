class ChangeStatusFieldToActive < ActiveRecord::Migration
  def up
    add_column :campaigns, :deleted_at, :time
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
    remove_column :campaigns, :deleted_at
  end
end
