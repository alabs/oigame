class AddMessagesCountToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :messages_count, :integer
  end
end
