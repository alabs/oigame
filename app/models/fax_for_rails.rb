class FaxForRails < ActiveRecord::Base
  
  attr_accessible :country, :rate, :credit, :reference

  TAX = 4

  def hello_world(*args)
  end
end
