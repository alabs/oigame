class AddLogobase64ToSubOigames < ActiveRecord::Migration
  def change
    add_column :sub_oigames, :logobase64, :text
  end
end
