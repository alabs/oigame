class AddRevalidateCounterToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :revalidate_counter, :integer
  end
end
