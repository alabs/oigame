class RemoveReferenceFromFaxForRails < ActiveRecord::Migration
  def up
    remove_column :fax_for_rails, :reference
  end

  def down
    add_column :fax_for_rails, :boolean
  end
end
