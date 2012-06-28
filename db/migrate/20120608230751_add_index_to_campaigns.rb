class AddIndexToCampaigns < ActiveRecord::Migration
  def change
    add_index :campaigns, :user_id
    add_index :campaigns, :sub_oigame_id
  end
end
