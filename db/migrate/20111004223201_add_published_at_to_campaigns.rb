class AddPublishedAtToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :published_at, :datetime
  end
end
