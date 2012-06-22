class AddIndexToTagsName < ActiveRecord::Migration
  def change
    add_index :tags, :name, :name => 'index_tags_on_name', :length => 254
  end
end
