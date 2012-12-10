class AddCheckStatusToFax < ActiveRecord::Migration
  def change
    add_column :faxes, :check_date, :datetime
    add_column :faxes, :check_message, :string
    add_column :faxes, :check_ticket_id, :integer
  end
end
