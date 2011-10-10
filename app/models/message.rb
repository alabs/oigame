class Message < ActiveRecord::Base

  belongs_to :campaign

  attr_accessible :campaign, :email
end
