class AddRevalidateCounterToFax < ActiveRecord::Migration
  def change
    add_column :faxes, :revalidate_counter, :integer
  end
end
