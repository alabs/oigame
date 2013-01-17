class AddVideoToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :video_url, :string
  end
end
