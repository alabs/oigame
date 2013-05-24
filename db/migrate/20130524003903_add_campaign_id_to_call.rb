class AddCampaignIdToCall < ActiveRecord::Migration
  def change
    add_column :calls, :campaign_id, :integer
  end
end
