class AddDefaultToWstatusInCampaigns < ActiveRecord::Migration
  def change
    remove_column :campaigns, :wstatus
    add_column :campaigns, :wstatus, :string, :default => 'inactive'
  end
end
