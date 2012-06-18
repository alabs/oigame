require 'raven'

Raven.configure do |config|
  config.dsn = "http://b66e78aac5ef4754bba8e04c3d171c56:bad2df3393284b608b41438531c6064a@sentry.alabs.es:9100/2"
  config.environments = %w[ staging production ]
end
