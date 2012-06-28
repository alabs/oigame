class AddLogoToSubOigame < ActiveRecord::Migration
  def change
    add_column :sub_oigames, :logo, :string
  end
end
