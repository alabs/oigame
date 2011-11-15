class ValidateAllMessages < ActiveRecord::Migration
  def up
    Message.all.each do |message|
      message.validated = true
      message.save
    end
  end

  def down
    Message.all.each do |message|
      message.validated = false
      message.save
    end
  end
end
