class AddMailMessageToSubOigame < ActiveRecord::Migration
  def change
    add_column :sub_oigames, :mail_message, :text
  end
end
