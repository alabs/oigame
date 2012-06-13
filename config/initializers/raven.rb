require 'raven'

Raven.configure do |config|
  host = '192.168.163.202'
  config.dsn = "http://b66e78aac5ef4754bba8e04c3d171c56:bad2df3393284b608b41438531c6064a@#{host}:9100/2"
  config.environments = %w[ staging production ]
end
