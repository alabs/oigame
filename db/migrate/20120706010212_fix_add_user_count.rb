class FixAddUserCount < ActiveRecord::Migration
  def up
    remove_column :users, :count
    add_column :users, :campaigns_count, :integer
  end

  def down
    remove_column :users, :campaigns_count
    add_column :users, :count, :integer
  end
end
