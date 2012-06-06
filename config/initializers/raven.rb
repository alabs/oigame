require 'raven'

Raven.configure do |config|
  if Rails.env == 'development'
    host = 'sentry.alabs.es'
  else
    host = '192.168.163.202'
  end
  config.dsn = "http://b66e78aac5ef4754bba8e04c3d171c56:bad2df3393284b608b41438531c6064a@#{host}:9100/2"
  config.environments = %w[ development staging production ]
end
