class AddIndexToSubOigames < ActiveRecord::Migration
  def change
    add_index :sub_oigames, :user_id
  end
end
