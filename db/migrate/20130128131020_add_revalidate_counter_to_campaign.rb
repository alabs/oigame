class AddRevalidateCounterToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :revalidate_counter, :integer
  end
end
