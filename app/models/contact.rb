class Contact < ActiveRecord::Base

  attr_accessible :name, :email, :subject, :body, :mailing

  validates_presence_of :name
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  validates_presence_of :body
end
