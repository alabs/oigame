class AddIndexToMessagesValidated < ActiveRecord::Migration
  def change
    add_index :messages, :validated
  end
end
