class AddDefaultMessageFieldsToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :default_message_subject, :string
    add_column :campaigns, :default_message_body, :text
  end
end
