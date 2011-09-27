class AddEmailsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :emails, :text
  end
end
