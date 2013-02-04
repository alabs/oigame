class ChangeColumnCampaignCredit < ActiveRecord::Migration
  def up
    change_column :campaigns, :credit, :integer
  end

  def down
    change_column :campaigns, :credit, :decimal, :precision => 10, :scale => 4, :default => 0.0
  end
end
