class CreateSubOigames < ActiveRecord::Migration
  def change
    create_table :sub_oigames do |t|
      t.string :name
      t.string :slug
      t.text :html_header
      t.text :html_footer
      t.text :html_style

      t.timestamps
    end
  end
end
