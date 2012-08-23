class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    auth = env["omniauth.auth"]

    # Guardar a un fichero en YAML auth
    #fh = File.new('/tmp/auth.yml', 'w')
    #fh.puts auth.to_yaml
    #fh.close

    @user = User.find_for_twitter_oauth(auth, current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_uid"] = auth["uid"]
      redirect_to new_user_registration_url(@user) 
    end
  end

  def passthru
    raise ActionController::RoutingError.new('Not Found')
  end
end
