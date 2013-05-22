class Update < ActiveRecord::Base

  belongs_to :campaign, :counter_cache => true

  attr_accessible :body

  validates_presence_of :body
  validates :body, :length => { :maximum => 150 }
end
