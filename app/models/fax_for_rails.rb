class FaxForRails < ActiveRecord::Base
  
  attr_accessible :country, :rate, :credit

  TAX = 4

  before_save :calculate_credit

  class << self
  end

  def calculate_credit 
  end

  protected
end
