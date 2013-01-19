class AddReferenceColumnToFaxRates < ActiveRecord::Migration
  def change
    add_column :fax_for_rails, :reference, :boolean
    add_index :fax_for_rails, :reference
  end
end
