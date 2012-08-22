Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, APP_CONFIG[:twitter_consumer_key], APP_CONFIG[:twitter_consumer_secret]
end
