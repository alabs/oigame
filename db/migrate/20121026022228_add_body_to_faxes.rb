class AddBodyToFaxes < ActiveRecord::Migration
  def change
    add_column :faxes, :body, :text
  end
end
