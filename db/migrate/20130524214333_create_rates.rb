class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.string   "country"  
      t.decimal  "rate",       :precision => 10, :scale => 4

      t.timestamps
    end
  end
end
