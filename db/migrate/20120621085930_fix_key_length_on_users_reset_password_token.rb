class FixKeyLengthOnUsersResetPasswordToken < ActiveRecord::Migration
  def up
    remove_index "users", :name => "index_users_on_reset_password_token"
    add_index :users, :reset_password_token, :name => "index_users_on_reset_password_token", :unique => true, :length => 254
  end

  def down
    remove_index :users, :name => "index_users_on_reset_password_token"
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end
end
