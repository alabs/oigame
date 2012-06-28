class AddIndexToSubOigamesDeletedAt < ActiveRecord::Migration
  def change
    add_index :sub_oigames, :deleted_at, :name => 'index_on_sub_oigames_deleted_at'
  end
end
