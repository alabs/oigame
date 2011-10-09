class AddDuetateAtToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :duedate_at, :datetime
  end
end
