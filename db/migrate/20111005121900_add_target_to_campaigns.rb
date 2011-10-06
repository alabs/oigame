class AddTargetToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :target, :string
  end
end
