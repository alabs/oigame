FACEBOOK_SCOPE = 'user_likes,publish_stream,publish_actions'

unless APP_CONFIG[:FACEBOOK_APP_ID] && APP_CONFIG[:FACEBOOK_SECRET]
  abort("missing env vars: please set FACEBOOK_APP_ID and FACEBOOK_SECRET with your app credentials")
end
