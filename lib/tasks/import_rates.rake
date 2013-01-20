def csv_ovh_rates
  resp = HTTParty.get('http://twitter.com/statuses/public_timeline.json')
  return resp.body
end

def import_csv
  require 'csv'    
  csv_text = File.read(csv_ovh_rates)
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

  FaxForRails.all(&:destroy)
  data.each do |d| 
    FaxForRails.create(:country => d[0], :rate => d[1])
  end
end

namespace :oigame do
  desc 'Import rates'
  task(:import_rates => :environment) do
    import_csv if ENV['FORMAT'] == 'csv'
  end
end
