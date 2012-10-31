class AddCreditToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :credit, :decimal, :precision => 10, :scale => 4
  end
end
