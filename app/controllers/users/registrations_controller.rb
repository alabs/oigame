class Users::RegistrationsController < Devise::RegistrationsController

  helper :application

  protected

  def after_update_path_for(resource)
    if session[:redirect_to_donate]
      donate_url = session[:redirect_to_donate]
      session[:redirect_to_donate] = nil
      donate_url
    elsif session[:redirect_to_add_credit]
      add_credit_url = session[:redirect_to_add_credit]
      session[:redirect_to_add_credit] = nil
      add_credit_url
    elsif session[:redirect_to_create_campaign]
      new_campaign_url = session[:redirect_to_create_campaign]
      session[:redirect_to_create_campaign] = nil
      new_campaign_url
    else
      super
    end
  end
end
