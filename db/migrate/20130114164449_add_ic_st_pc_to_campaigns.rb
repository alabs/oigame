class AddIcStPcToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :identity_card, :boolean, :default => false
    add_column :campaigns, :state, :boolean, :default => false
    add_column :campaigns, :postal_code, :boolean, :default => false
  end
end
