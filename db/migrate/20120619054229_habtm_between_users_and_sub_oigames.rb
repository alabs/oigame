class HabtmBetweenUsersAndSubOigames < ActiveRecord::Migration
  def up
    create_table :sub_oigames_users, :id => false do |t|
      t.integer :sub_oigame_id
      t.integer :user_id
    end
    remove_column :sub_oigames, :user_id
  end

  def down
    drop_table :sub_oigames_users
    add_column :sub_oigames, :user_id, :integer
  end
end
