class AddTtypeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :ttype, :string
  end
end
