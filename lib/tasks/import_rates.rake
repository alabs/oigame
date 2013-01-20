def import_csv(file)
  require 'csv'    
  csv_text = File.read(file)
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    row = row.to_hash.with_indifferent_access
    #FaxForRails.create!(row.to_hash.symbolize_keys)
    puts row.to_hash.symbolize_keys
  end
end

namespace :oigame do
  desc 'Import rates'
  task(:import_rates => :environment) do
    if ENV['FORMAT'] == 'csv'
      import_csv(ENV['DB'])
    end
  end
end
