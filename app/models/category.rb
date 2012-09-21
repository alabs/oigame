class Category < ActiveRecord::Base

  has_many :campaigns
  
  attr_accessible :name
end
