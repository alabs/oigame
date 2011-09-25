class AddImageToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :image, :string
  end
end
