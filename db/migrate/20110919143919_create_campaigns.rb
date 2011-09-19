class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :slug
      t.text :intro
      t.text :body

      t.timestamps
    end
  end
end
