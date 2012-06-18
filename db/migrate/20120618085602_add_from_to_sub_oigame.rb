class AddFromToSubOigame < ActiveRecord::Migration
  def change
    add_column :sub_oigames, :from, :string
  end
end
