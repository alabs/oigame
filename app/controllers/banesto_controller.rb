class BanestoController < ApplicationController

  http_basic_authenticate_with :name => "gateway", :password => APP_CONFIG[:gw_pass]
  
  skip_before_filter :verify_authenticity_token

  def payment_accepted
    campaign = Campaign.find_by_slug(params[:id])
    campaign.credit += (params[:amount] / FaxForRails::TAX)
    campaign.save
    flash[:notice] = t(:payment_accepted)
    redirect_to campaign
  end
end
