class BanestoController < ApplicationController

  http_basic_authenticate_with :name => "gateway", :password => APP_CONFIG[:gw_pass]
  
  protect_from_forgery :except => [:payment_accepted]

  def payment_accepted
    campaign = Campaign.find_by_slug(params[:campaign_slug])
    campaign.credit += (FaxForRails::TAX / params[:amount])
    campaign.save
  end
end
