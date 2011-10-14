class AddNameAndVatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :vat, :string
  end
end
