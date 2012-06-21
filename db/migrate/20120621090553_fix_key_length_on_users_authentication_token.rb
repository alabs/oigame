class FixKeyLengthOnUsersAuthenticationToken < ActiveRecord::Migration
  def up
    add_column :users, :authentication_token, :string
    remove_index(:users, :name => 'index_users_on_authentication_token') rescue nil
    add_index :users, :authentication_token, :name => 'index_users_on_authentication_token', :unique => true, :length => 254
  end

  def down
    remove_index :users, :name => 'index_users_on_authentication_token'
    add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
    remove_column :users, :authentication_token
  end
end
