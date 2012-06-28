class AddIndexOnCampaignsStatusAndCampaignDeletedAt < ActiveRecord::Migration
  def up
    add_index :campaigns, :status, :name => 'index_on_campaigns_status'
    add_index :campaigns, :deleted_at, :name => 'index_on_campaigns_deleted_at'
  end

  def down
    remove_index :campaigns, :name => 'index_on_campaigns_status'
    remoev_index :campaigns, :name => 'index_on_campaigns_deleted_at'
  end
end
