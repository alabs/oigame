class AddIndexToPetitionsValidated < ActiveRecord::Migration
  def change
    add_index :petitions, :validated
  end
end
