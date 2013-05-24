class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.integer :number

      t.timestamps
    end
  end
end
