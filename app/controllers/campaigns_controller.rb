# encoding: utf-8
class CampaignsController < ApplicationController

  protect_from_forgery :except => :message 
  layout 'application', :except => [:widget, :widget_iframe]
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy, :moderated, :activate]

  # para cancan
  load_resource :find_by => :slug
  skip_load_resource :only => [:index, :tag, :message, :moderated, :feed]
  authorize_resource
  skip_authorize_resource :only => [:index, :tag, :message, :feed]

  def index
    @campaigns = Campaign.last_campaigns
    @tags = Campaign.published.tag_counts_on(:tags)
  end

  def show
    @stats_data = generate_stats(@campaign)
    @image_src = @campaign.image_url.to_s
    @description = @campaign.name
    @tags = @campaign.tag_list.join(', ')
  end

  def new
  end

  def edit
  end

  def create
    @campaign.user = current_user
    if @campaign.save
      Mailman.send_campaign_to_social_council(@campaign).deliver
      flash[:notice] = 'Tu campaña se ha creado con éxito y está pendiente de moderación.'
      redirect_to campaigns_url
    else
      render :action => :new
    end
  end

  def update
    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = 'La campaña fué actualizada con éxito.'
      redirect_to @campaign
    else
      render :action => :edit
    end
  end

  def destroy
    @campaign.destroy
    flash[:notice] = 'La campaña se eliminió con éxito'
    redirect_to campaigns_url
  end

  def widget
  end

  def widget_iframe
    render :partial => "widget_iframe"
  end

  def tag
    @campaigns = Campaign.last_campaigns_by_tag(params[:id])
    @tags = Campaign.published.tag_counts_on(:tags)
  end

  def message
    if request.post?
      to = user_signed_in? ? current_user.email : params[:email]
      campaign = Campaign.published.find_by_slug(params[:id])
      Message.create(:campaign => campaign, :email => to)
      Mailman.send_message_to_user(to, params[:subject], params[:body], campaign).deliver
      redirect_to message_campaign_path, :notice => 'Gracias por unirte a esta campaña'

      return
    end
    @campaign = Campaign.published.find_by_slug(params[:id])
    @stats_data = generate_stats(@campaign)
  end

  def moderated
    @campaigns = Campaign.last_campaigns_moderated
    @tags = Campaign.published.tag_counts_on(:tags)
  end

  def activate
    @campaign.activate!
    redirect_to @campaign, :notice => 'La campaña se ha activado con éxito'
  end

  def deactivate
    @campaign.deactivate!
    redirect_to @campaign, :notice => 'Campaña desactivada con éxito'
  end

  def feed
    @campaigns = Campaign.last_campaigns
  end

  private

  def generate_stats(campaign)
    dates = (campaign.created_at.to_date..Date.today).map{ |date| date.to_date }
    data = []
    dates.each do |date|
      data.push([date.strftime('%Y-%m-%d'), Message.where(:created_at => (date..date.tomorrow.to_date)).where(:campaign_id => campaign.id).all.count])
    end
    
    return data
  end
end
