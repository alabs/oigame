class AddSubOigameIdToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :sub_oigame_id, :integer
  end
end
