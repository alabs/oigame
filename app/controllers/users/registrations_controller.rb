class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def after_update_path_for(resource)
    if session[:redirect_to_donate]
      donate_url = session[:redirect_to_donate]
      session[:redirect_to_donate] = nil
      donate_url
    else
      super
    end
  end
end
