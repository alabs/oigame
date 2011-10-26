class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.integer :campaign_id
      t.string :email

      t.timestamps
    end
  end
end
