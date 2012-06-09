class AddIndexToCampaignsSlug < ActiveRecord::Migration
  def change
    add_index :campaigns, :slug
  end
end
