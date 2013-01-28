def csv_ovh_rates
  resp = HTTParty.get('https://www.ovh.co.uk/cgi-bin/telephony/callRateCsv.cgi')
  file = File.new('/tmp/ovh_fax_rates.csv', 'w')
  file.puts resp.body
  file.close
end

def import_csv
  require 'csv'    
  csv_text = File.read('/tmp/ovh_fax_rates.csv')
  csv = CSV.parse(csv_text, :headers => true)
  data = []
  csv.each do |row|
    r = row.to_s.split(';')
    r.delete_at(0)
    typ = r.delete_at(0)
    if typ == 'fixe'
      # limpieza
      r[0].gsub!(/-\d/, '')
      r[1].strip!

      data << r 
    end
  end

  return data
end

def destroy_and_create
  FaxForRails.all(&:destroy)
  csv_ovh_rates
  data = import_csv
  data.each do |d|
    f4r = FaxForRails.create!(:country => d[0], :rate => d[1])
    puts "#{f4r.country}: #{f4r.rate}"
  end
end

namespace :oigame do
  desc 'Import FAX rates from OVH'
  task(:import_fax_rates => :environment) do
    destroy_and_create if ENV['FORMAT'] == 'csv'
  end
end
