FACEBOOK_SCOPE = 'user_likes,user_photos,user_photo_video_tags'

unless APP_CONFIG[:FACEBOOK_APP_ID] && APP_CONFIG[:FACEBOOK_SECRET]
  abort("missing env vars: please set FACEBOOK_APP_ID and FACEBOOK_SECRET with your app credentials")
end
