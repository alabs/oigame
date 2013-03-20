# encoding: utf-8
class FacebookController < ApplicationController
  def create_action
    if current_user
      user_provider = current_user.user_providers.where(provider: 'facebook').first
      if user_provider
        op = Facebook::OpenGraph.new(user_provider.uid,APP_CONFIG[:FACEBOOK_APP_ID])
        sess = session[:fb_sess]
        campaign = Campaign.find(sess[:id])
        fb_url = campaign_url campaign
        op.send_action(campaign.ttype,fb_url)
        redirect_to signed_campaign_url(campaign)
      else
        session[:user_return_to] = facebook_create_action_url
        redirect_to user_omniauth_authorize_path(:facebook)
      end
    else
      session[:user_return_to] = facebook_create_action_url
      redirect_to user_omniauth_authorize_path(:facebook)
    end
  end
end
