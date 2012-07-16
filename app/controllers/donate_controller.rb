class DonateController < ApplicationController

  before_filter :authenticate_user!, :only => [:init]

  def index
  end

  def init
    unless current_user.ready_for_donation
      session[:redirect_to_donate] = "http://oiga.me/donate/init"
      flash[:error] = 'Necesitamos que nos digas tu nombre y NIF para donar'
      redirect_to edit_user_registration_path

      return
    end
    
    @reference = secure_digest(Time.now, (1..10).map { rand.to_s})[0,29]

    data = {}
    data[:reference] = @reference
    data[:name] = current_user.name
    data[:vat] = current_user.vat
    data[:email] = current_user.email
    HTTParty.post("http://#{APP_CONFIG[:gw_domain]}/pre", :body => data)
  end

  def accepted
  end

  def denied
  end
  
  private
  
  def secure_digest(*args)
    require 'digest/sha1'
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
end
