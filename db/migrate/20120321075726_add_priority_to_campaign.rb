class AddPriorityToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :priority, :boolean
  end
end
