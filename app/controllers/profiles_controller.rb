class ProfilesController < ApplicationController


  def show
  end

  def clean_user_parameters
    cookies[:name] = ""
    cookies[:email] = ""

    redirect_to request.referer
  end

end
