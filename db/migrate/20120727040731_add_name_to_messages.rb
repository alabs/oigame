class AddNameToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :name, :string
  end
end
