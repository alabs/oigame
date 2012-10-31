class CreateFaxes < ActiveRecord::Migration
  def change
    create_table :faxes do |t|
      t.integer :campaign_id
      t.string :email
      t.boolean :validated
      t.string :token
      t.string :name

      t.timestamps
    end
  end
end
