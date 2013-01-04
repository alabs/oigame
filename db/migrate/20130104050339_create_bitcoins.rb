class CreateBitcoins < ActiveRecord::Migration
  def change
    create_table :bitcoins do |t|

      t.timestamps
    end
  end
end
