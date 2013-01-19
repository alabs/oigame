namespace :oigame:rates do
  desc 'Import rates'
  task(:import_rates) do
    db = ENV['db']
    if db.is_a_csv?
    elsif db.is_a_json_uri?
      # TODO
    elsif
      # ETC
    end
  end
end
