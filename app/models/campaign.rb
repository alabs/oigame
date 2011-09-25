class Campaign < ActiveRecord::Base

  belongs_to :user
  
  attr_accessible :name, :intro, :body, :tag_list

  validates_presence_of :name, :intro, :body
  validates_uniqueness_of :name

  acts_as_taggable
end
