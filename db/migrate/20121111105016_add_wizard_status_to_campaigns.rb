class AddWizardStatusToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :wstatus, :string
  end
end
