class FaxForRails < ActiveRecord::Base
  
  # attr_accessible :country, :rate, :credit, :reference
  # borrar esas columnas inncesarias
  attr_accessible :country, :rate

  OVH_RATE = 0.02
  BANESTO_RATE = 28 #2.8%

  TAX = OVH_RATE + (OVH_RATE  * "0.0#{BANESTO_RATE}".to_f)
end
