module Facebook

  def init
    @graph = Koala::Facebook::API.new(session[:access_token])
    @app = @graph.get_object(APP_CONFIG[:FACEBOOK_APP_ID])
    if session[:access_token]
      @fbuser = @graph.get_object("me")
      logger.debug('DEBUG FB USER: ' + @fbuser.inspect)
    end
  end

  def authenticator
    Koala::Facebook::OAuth.new(APP_CONFIG[:FACEBOOK_APP_ID], APP_CONFIG[:FACEBOOK_SECRET], facebook_callback_url)
  end

  def auth
    session[:access_token] = nil
    redirect_to authenticator.url_for_oauth_code(:permissions => FACEBOOK_SCOPE)
  end

  def callback
    session[:access_token] = authenticator.get_access_token(params[:code])
    # ejecutar cosas
    logger.debug('DEBUG ACCESS TOKEN: ' + session[:access_token].inspect)
    init
    campaign_id = session[:fb_sess_campaign]
    session[:fb_sess_campaign] = nil
    campaign = Campaign.find(campaign_id)
    options = { :body => { :session_token => session[:access_token], :campaign => campaign_url(campaign), "fb:explicitly_shared" => true } }
    resp = HTTParty.post('http://graph.facebook.com/me/oigameapp:sign', options)
    logger.debug('DEBUG HTTP RESPONSE: ' + resp.inspect)
    redirect_to root_path
  end

  def destroy
    session[:access_token] = nil
    redirect_to '/'
  end
end
