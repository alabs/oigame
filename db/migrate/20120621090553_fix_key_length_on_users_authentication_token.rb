class FixKeyLengthOnUsersAuthenticationToken < ActiveRecord::Migration
  def up
    remove_index :users, :name => 'index_users_on_authentication_token'
    add_index :users, :authentication_token, :name => 'index_users_on_authentication_token', :unique => true, :length => 254
  end

  def down
    remove_index :users, :name => 'index_users_on_authentication_token'
    add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  end
end
