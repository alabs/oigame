class AddUserIdToSubOigame < ActiveRecord::Migration
  def change
    add_column :sub_oigames, :user_id, :integer
  end
end
