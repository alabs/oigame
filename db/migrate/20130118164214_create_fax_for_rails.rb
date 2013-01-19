class CreateFaxForRails < ActiveRecord::Migration
  def change
    create_table :fax_for_rails do |t|

      t.string :country
      t.integer :rate
      t.integer :credit
      t.timestamps
    end
  end
end
