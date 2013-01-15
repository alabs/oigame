class Update < ActiveRecord::Base

  belongs_to :campaign

  attr_accessible :body
end
