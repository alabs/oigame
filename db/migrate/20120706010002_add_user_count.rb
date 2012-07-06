class AddUserCount < ActiveRecord::Migration
  def up
    add_column :users, :count, :integer
  end

  def down
    remove_column :users, :count
  end
end
