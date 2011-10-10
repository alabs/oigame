class AddEmailToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :email, :string
  end
end
