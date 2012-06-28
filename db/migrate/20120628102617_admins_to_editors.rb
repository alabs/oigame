class AdminsToEditors < ActiveRecord::Migration
  def up
    users = User.where(:role => 'admin').all
    users.each {|user| user.update_attribute('role', 'editor') }
  end

  def down
    users = User.where(:role => 'editor').all
    users.each {|user| user.update_attribute('role', 'admin') }
  end
end
