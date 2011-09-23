class Campaign < ActiveRecord::Base

  attr_accessible :name, :intro, :body

  belongs_to :user

  validates_presence_of :name, :intro, :body
  validates_uniqueness_of :name
end
