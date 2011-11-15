class AddBodyToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :body, :text
  end
end
