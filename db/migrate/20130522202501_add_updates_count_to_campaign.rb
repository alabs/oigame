class AddUpdatesCountToCampaign < ActiveRecord::Migration

  def self.up
    add_column :campaigns, :updates_count, :integer, :default => 0

    Campaign.reset_column_information
    Campaign.find(:all).each do |c|
      Campaign.update_counters c.id, :updates_count => c.updates.length
    end
  end

  def self.down
    remove_column :campaigns, :updates_count
  end

end
