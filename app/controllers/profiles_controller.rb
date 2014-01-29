class ProfilesController < ApplicationController


  def show
    @user = User.find(params[:username])
    @published_campaigns = @user.campaigns.published
    @unpublished_campaigns = @user.campaigns.not_published
  end

  def clean_user_parameters
    cookies[:name] = ""
    cookies[:email] = ""

    redirect_to request.referer
  end

end
