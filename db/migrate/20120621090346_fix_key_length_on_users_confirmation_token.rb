class FixKeyLengthOnUsersConfirmationToken < ActiveRecord::Migration
  def up
    remove_index(:users, :name => "index_users_on_confirmation_token") rescue nil
    add_index :users, :confirmation_token, :name => "index_users_on_confirmation_token", :unique => true, :length => 254
  end

  def down
    remove_index :users, :name => 'index_users_on_confirmation_token'
    add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  end
end
