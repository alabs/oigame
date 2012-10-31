class ChangeFaxesToNumbersInCampaigns < ActiveRecord::Migration
  def up
    rename_column :campaigns, :faxes, :numbers
  end

  def down
    rename_column :campaigns, :numbers, :faxes
  end
end
