class AddNameToPetitions < ActiveRecord::Migration
  def change
    add_column :petitions, :name, :string
  end
end
