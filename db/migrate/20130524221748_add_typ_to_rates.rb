class AddTypToRates < ActiveRecord::Migration
  def change
    add_column :rates, :typ, :string
  end
end
