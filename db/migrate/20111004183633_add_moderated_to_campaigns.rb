class AddModeratedToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :moderated, :boolean, :default => true
  end
end
