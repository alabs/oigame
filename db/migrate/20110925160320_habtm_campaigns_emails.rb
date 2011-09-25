class HabtmCampaignsEmails < ActiveRecord::Migration

  def change
    create_table :campaigns_emails, :id => false do |t|
      t.integer :campaign_id
      t.integer :email_id
    end
  end
end
