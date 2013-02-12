class FaxForRails < ActiveRecord::Base
  
  # attr_accessible :country, :rate, :credit, :reference
  # borrar esas columnas inncesarias
  attr_accessible :country, :rate

  TAX = 0.02
end
