class AddIndexToSubOigameSlug < ActiveRecord::Migration
  def change
    add_index :sub_oigames, :slug
  end
end
