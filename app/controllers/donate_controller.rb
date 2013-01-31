class DonateController < ApplicationController

  before_filter :authenticate_user!, :only => [:init]
  
  # para declarative_auth
  filter_access_to :all

  def index
  end

  def confirm

    if params[:name].blank? 
      flash[:error] = t(:we_need_your_name_to_donate)
      redirect_to donate_path
    end

    @reference = secure_digest(Time.now, (1..10).map { rand.to_s})[0,29]

    @data = {}
    @data[:reference] = @reference
    @data[:name] = params[:name]
    @data[:idcard] = params[:idcard]
    @data[:email] = params[:email]
    @coste = params[:coste]
    HTTParty.post("http://#{APP_CONFIG[:gw_domain]}/pre", :body => @data)

  end

  def accepted
  end

  def denied
  end
end
