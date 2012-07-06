class AddCampaignCountToSubOigame < ActiveRecord::Migration
  def change
    add_column :sub_oigames, :campaigns_count, :integer
  end
end
