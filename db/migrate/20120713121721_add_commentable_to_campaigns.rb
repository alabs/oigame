class AddCommentableToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :commentable, :boolean, :default => true
  end
end
