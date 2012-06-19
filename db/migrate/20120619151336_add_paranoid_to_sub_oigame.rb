class AddParanoidToSubOigame < ActiveRecord::Migration
  def change
    add_column :sub_oigames, :deleted_at, :time
  end
end
