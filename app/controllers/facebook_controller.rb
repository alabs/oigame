class FacebookController < ApplicationController
  def send_action
    if current_user
      user_provider = current_user.user_providers.where(provider: 'facebook').first
      if user_provider
        op = Facebook::OpenGraph.new(user_provider.uid,ENV['app_id'])
        op.send_action(cookies['fb_action'])
      else
        session[:return_to] = facebook_send_action_url
        redirect_to omniauth
      end
    else
      session[:return_to] = facebook_send_action_url
      redirect_to omniauth
    end
  end
end
