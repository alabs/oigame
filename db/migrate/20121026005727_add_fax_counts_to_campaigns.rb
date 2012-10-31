class AddFaxCountsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :faxes_count, :integer, :default => 0
  end
end
