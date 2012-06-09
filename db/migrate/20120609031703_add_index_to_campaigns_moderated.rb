class AddIndexToCampaignsModerated < ActiveRecord::Migration
  def change
    add_index :campaigns, :moderated
  end
end
