module Facebook

  def initialize
    @graph = Koala::Facebook::API.new(session[:access_token])
    @app = @graph.get_object(APP_CONFIG[:FACEBOOK_APP_ID])
    if session[:access_token]
      @fbuser = @graph.get_object("me")
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
    redirect_to root_path
  end

  def destroy
    session[:access_token] = nil
    redirect_to '/'
  end
end
