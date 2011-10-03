class AddMailingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mailing, :boolean, :default => false
  end
end
