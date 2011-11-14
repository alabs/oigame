class AddStatusToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :status, :string
  end
end
