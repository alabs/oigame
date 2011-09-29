# encoding: utf-8
class CampaignsController < ApplicationController

  layout 'application', :except => [:widget, :widget_iframe]

  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]

  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = Campaign.last_campaigns
    @tags = Campaign.tag_counts_on(:tags)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
    end
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    @campaign = Campaign.find_by_slug(params[:id])
    
    # @stats_data es: [fecha, mensajes enviados]
    @stats_data = '[["2011-09-23 4:00PM",3023], ["2011-09-24 4:00PM",6023],  ["2011-09-25 4:00PM",16023],  ["2011-09-26 4:00PM",26023],  ["2011-09-27 4:00PM",46023]]'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @campaign }
    end
  end

  # GET /campaigns/new
  # GET /campaigns/new.json
  def new
    @campaign = Campaign.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @campaign }
    end
  end

  # GET /campaigns/1/edit
  def edit
    @campaign = Campaign.find_by_slug(params[:id])
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(params[:campaign])
    @campaign.user = current_user

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render json: @campaign, status: :created, location: @campaign }
      else
        format.html { render action: "new" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /campaigns/1
  # PUT /campaigns/1.json
  def update
    @campaign = Campaign.find_by_slug(params[:id])

    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign = Campaign.find_by_slug(params[:id])
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to campaigns_url }
      format.json { head :ok }
    end
  end

  def widget
    @campaign = Campaign.find_by_slug(params[:id])
  end

  def widget_iframe
    @campaign = Campaign.find_by_slug(params[:id])
  end

  def tag
    @campaigns = Campaign.last_campaigns_by_tag(params[:id])
    @tags = Campaign.tag_counts_on(:tags)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
    end
  end

  def message
    if request.post?
      to = user_signed_in? ? current_user.email : params[:email]
      campaign = Campaign.find_by_slug(params[:id])
      Mailman.send_message_to_user(to, params[:subject], params[:body], campaign).deliver
      redirect_to message_campaign_path, :notice => 'Gracias por unirte a esta campaña'

      return
    end
  end
end
