class AddFaxesToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :faxes, :text
  end
end
