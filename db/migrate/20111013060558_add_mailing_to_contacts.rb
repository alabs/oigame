class AddMailingToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :mailing, :boolean, :default => false
  end
end
