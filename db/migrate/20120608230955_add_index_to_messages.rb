class AddIndexToMessages < ActiveRecord::Migration
  def change
    add_index :messages, :campaign_id
  end
end
