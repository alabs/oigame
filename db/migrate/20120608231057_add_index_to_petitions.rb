class AddIndexToPetitions < ActiveRecord::Migration
  def change
    add_index :petitions, :campaign_id
  end
end
