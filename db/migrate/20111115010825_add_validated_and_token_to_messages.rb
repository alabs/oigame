class AddValidatedAndTokenToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :validated, :boolean, :default => false
    add_column :messages, :token, :string
  end
end
