class AddCpStateToPetitionsMessagesFaxes < ActiveRecord::Migration
  def change
    add_column :petitions, :postal_code, :string
    add_column :petitions, :state, :string
    add_column :messages, :postal_code, :string
    add_column :messages, :state, :string
    add_column :faxes, :postal_code, :string
    add_column :faxes, :state, :string
  end
end
