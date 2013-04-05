class Tweet < ActiveRecord::Base
  attr_accessible :msg

  def self.last_messages(section)
    self.order('created_at DESC').limit(1)
  end
end
