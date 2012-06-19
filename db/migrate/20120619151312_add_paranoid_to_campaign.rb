class AddParanoidToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :deleted_at, :time
  end
end
