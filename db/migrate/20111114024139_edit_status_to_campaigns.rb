class EditStatusToCampaigns < ActiveRecord::Migration
  def up
    change_column :campaigns, :status, :string, :default => 'active'
  end

  def down
    change_column :campaigns, :status, :string
  end
end
