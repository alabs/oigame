class ProfilesController < ApplicationController


  def show
    @user = User.find(params[:user])
  end
end
