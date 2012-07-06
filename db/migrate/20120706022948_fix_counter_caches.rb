class FixCounterCaches < ActiveRecord::Migration
  def up
    change_column :campaigns, :messages_count, :integer, :default => 0
    change_column :campaigns, :petitions_count, :integer, :default => 0
    Campaign.reset_column_information
    Campaign.find(:all).each do |c|
      c.messages_count = c.messages.length
      c.petitions_count = c.petitions.length
      c.save
    end

    change_column :sub_oigames, :campaigns_count, :integer, :default => 0
    SubOigame.reset_column_information
    SubOigame.find(:all).each do |s|
      s.campaigns_count = s.campaigns.length
      s.save
    end

    change_column :users, :campaigns_count, :integer, :default => 0
    User.reset_column_information
    User.find(:all).each do |u|
      u.campaigns_count = u.campaigns.length
      u.save
    end
  end
end
