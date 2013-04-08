class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :msg

      t.timestamps
    end
  end
end
