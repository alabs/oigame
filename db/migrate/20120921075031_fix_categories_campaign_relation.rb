class FixCategoriesCampaignRelation < ActiveRecord::Migration
  def up
    remove_column :categories, :campaign_id
    add_column :campaigns, :category_id, :integer
  end

  def down
    add_column :categories, :campaign_id, :integer
    remove_column :camapaigns, :category_id
  end
end
