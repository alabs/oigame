class Campaign < ActiveRecord::Base

  attr_accessible :name, :intro, :body

  belongs_to :user
end
