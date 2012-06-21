class FixKeyLengthOnSubOigamesSlugUnique < ActiveRecord::Migration
  def up
    remove_index :sub_oigames, :name => 'index_sub_oigames_on_slug'
    add_index :sub_oigames, :slug, :name => "index_sub_oigames_on_slug", :length => 254, :unique => true
  end

  def down
    remove_index :sub_oigames, :name => 'index_sub_oigames_on_slug'
    add_index :sub_oigames, :slug, :name => 'index_sub_oigames_on_slug', :length => 254
  end
end
