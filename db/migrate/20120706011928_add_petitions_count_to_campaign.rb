class AddPetitionsCountToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :petitions_count, :integer
  end
end
