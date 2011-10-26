class AddValidatedAndHashToPetition < ActiveRecord::Migration
  def change
    add_column :petitions, :validated, :boolean, :default => false
    add_column :petitions, :token, :string
  end
end
