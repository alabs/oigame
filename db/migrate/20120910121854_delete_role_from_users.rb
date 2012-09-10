class DeleteRoleFromUsers < ActiveRecord::Migration
  def up

    users = User.where(:role => 'user').all
    users.each do |user|
      user.roles = %w[user]
      user.save
    end
    
    editors = User.where(:role => 'editor').all
    editors.each do |editor|
      editor.roles = %w[editor]
      editor.save
    end

    admins = User.where(:role => 'admin').all
    admins.each do |admin|
      admin.roles = %w[admin]
      admin.save
    end

    remove_column :users, :role
  end

  def down

    add_column :users, :role, :string, :default => 'user'
  end
end
