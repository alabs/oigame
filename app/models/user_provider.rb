class UserProvider < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id
  belongs_to :user
end
