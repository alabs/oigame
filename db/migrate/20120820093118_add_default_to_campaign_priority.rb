class AddDefaultToCampaignPriority < ActiveRecord::Migration
  def change
    change_column :campaigns, :priority, :boolean, :default => false
  end
end
