class FixAddCreditToCampaigns < ActiveRecord::Migration
  def up
    remove_column :campaigns, :credit
    add_column :campaigns, :credit, :decimal, :precision => 10, :scale => 4, :default => 0
  end

  def down
    remove_column :campaigns, :credit
    add_column :campaigns, :credit, :decimal, :precision => 10, :scale => 4
  end
end
