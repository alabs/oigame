class AddRevalidateCounterToPetition < ActiveRecord::Migration
  def change
    add_column :petitions, :revalidate_counter, :integer
  end
end
