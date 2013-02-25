class CreateUserProviders < ActiveRecord::Migration
  def up
    create_table :user_providers do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid

      t.timestamps
    end

    UserProvider.reset_column_information
    User.all.each do |user|
      unless user.provider.blank?
        up = UserProvider.new
        up.user = user
        up.provider = user.provider
        up.uid = user.uid
        up.save!
      end
    end
  end

  def down
    drop_table :user_providers
  end
end
