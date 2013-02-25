class AddCheckCodeToFax < ActiveRecord::Migration
  def change
    add_column :faxes, :check_code, :integer
  end
end
