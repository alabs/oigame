class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :user_id
      t.integer :campaign_id
      t.decimal :amount, :precision => 10, :scale => 4, :default => 0

      t.timestamps
    end
  end
end
