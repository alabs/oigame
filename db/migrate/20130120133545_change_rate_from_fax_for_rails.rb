class ChangeRateFromFaxForRails < ActiveRecord::Migration
  def up
    change_column :fax_for_rails, :rate, :decimal, :precision => 10, :scale => 4
  end

  def down
    change_column :fax_for_rails, :rate, :integer
  end
end
