class InformLowCreditInCampaigns < ActiveRecord::Migration
  def up
    add_column :campaigns, :informed_low_credit, :boolean, :default => false
  end

  def down
    remove_column :campaigns, :informed_low_credit
  end
end
