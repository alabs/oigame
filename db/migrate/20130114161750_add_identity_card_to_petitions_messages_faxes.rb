class AddIdentityCardToPetitionsMessagesFaxes < ActiveRecord::Migration
  def change
    add_column :petitions, :identity_card, :string
    add_column :messages, :identity_card, :string
    add_column :faxes, :identity_card, :string
  end
end
