require 'raven'

Raven.configure do |config|
  config.dsn = "http://f2f42f62a30946028c62b3b8627738ad:03992acd27ff4c3d99fe5b168e665931@sentry.alabs.es/2"
  config.environments = %w[ staging production ]
end
