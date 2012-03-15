# encoding: utf-8
class CampaignsController < ApplicationController

  protect_from_forgery :except => [:message, :petition]
  layout :sub_oigame_layout, :except => [:widget, :widget_iframe]
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy, :moderated, :activate]

  # para cancan
  load_resource :find_by => :slug
  skip_load_resource :only => [:index, :tag, :tags_archived, :message, :moderated, :feed, :archived]
  authorize_resource
  skip_authorize_resource :only => [:index, :tag, :tags_archived, :message, :feed]

  def index
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]

    if @sub_oigame.nil? 
      # si no es de un suboigame
      @campaigns = Campaign.where(:sub_oigame_id => nil).includes(:messages, :petitions).last_campaigns
      @tags = Campaign.where(:sub_oigame_id => nil).published.tag_counts_on(:tags)
    else
      # si es de un suboigame
      @campaigns = Campaign.where(:sub_oigame_id => @sub_oigame).includes(:messages, :petitions).last_campaigns
      @tags = Campaign.where(:sub_oigame_id => @sub_oigame).published.tag_counts_on(:tags)
    end
  end

  def show
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    # para que funcione el botón de facebook
    @cause = true

    if @campaign.ttype == 'petition'
      @stats_data = generate_stats_for_petition(@campaign)
    elsif @campaign.ttype == 'mailing'
      @stats_data = generate_stats_for_mailing(@campaign)
    end
    @image_src = @campaign.image_url.to_s
    @image_file = @campaign.image.file.file
    @description = @campaign.name
    @keywords = @campaign.tag_list.join(', ')
  end

  def new
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
  end

  def edit
  end

  def create
    @campaign.user = current_user
    @campaign.target = @campaign.target.gsub(/\./, '')
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    if @sub_oigame then @campaign.sub_oigame = @sub_oigame end
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

  def tags_archived
    @archived = true
    @campaigns = Campaign.last_campaigns_by_tag_archived(params[:id])
    @tags = Campaign.archived.tag_counts_on(:tags)
  end

  def message
    if request.post?
      from = user_signed_in? ? current_user.email : params[:email]
      campaign = Campaign.published.find_by_slug(params[:id])
      if campaign
        message = Message.create(:campaign => campaign, :email => from, :subject => params[:subject], :body => params[:body], :token => generate_token)
        Mailman.send_message_to_validate_message(from, campaign, message).deliver
        redirect_to message_campaign_path, :notice => 'Gracias por unirte a esta campaña'

        return
      else
        flash[:error] = "Esta campaña ya no está activa."
        redirect_to campaigns_path
      end
    else
      @campaign = Campaign.published.find_by_slug(params[:id])
      if @campaign
        @stats_data = generate_stats_for_mailing(@campaign)
      else
        flash[:error] = "Esta campaña ya no está activa."
        redirect_to campaigns_path
      end
    end
  end

  def petition
    if request.post?
      if user_signed_in?
        if current_user.name.blank?
          current_user.update_attributes(:name => params[:name])
        end
      end
      to = user_signed_in? ? current_user.email : params[:email]
      campaign = Campaign.published.find_by_slug(params[:id])
      petition = Petition.create(:campaign => campaign, :name => params[:name], :email => to, :token => generate_token )
      Mailman.send_message_to_validate_petition(to, campaign, petition).deliver
      redirect_to petition_campaign_path, :notice => 'Gracias por unirte a esta campaña'

      return
    end
    @campaign = Campaign.published.find_by_slug(params[:id])
    @stats_data = generate_stats_for_petition(@campaign)
  end

  def validate
    model = Message.find_by_token(params[:token]) || Petition.find_by_token(params[:token])
    if model
      model.update_attributes(:validated => true, :token => nil)
      # Enviar el mensaje si model es Message
      if model.class.name == 'Message'
        Mailman.send_message_to_recipients(model).deliver
      end
      redirect_to validated_campaign_path, :notice => 'Tu adhesión se ha ejecutado con éxito'

      return
    else
      render
    end
  end
  
  def validated
    @stats_data = generate_stats_for_petition(@campaign)
  end

  def moderated
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]

    if @sub_oigame.nil? 
      @campaigns = Campaign.where(:sub_oigame_id => nil).last_campaigns_moderated
      @tags = Campaign.where(:sub_oigame_id => nil).published.tag_counts_on(:tags)
    else
      @campaigns = Campaign.where(:sub_oigame_id => @sub_oigame).last_campaigns_moderated
      @tags = Campaign.where(:sub_oigame_id => @sub_oigame).published.tag_counts_on(:tags)
    end
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
    @campaigns = Campaign.last_campaigns(10)
    set_http_cache(3.hours, visibility = true)
  end

  def archive
    @campaign.archive
    redirect_to @campaign, :notice => 'La campaña ha sido archivada con éxito'
  end

  def archived
    @archived = true
    @campaigns = Campaign.archived_campaigns
    @tags = Campaign.archived.tag_counts_on(:tags)
  end

  private

    def generate_stats_for_mailing(campaign)
      dates = (campaign.created_at.to_date..Date.today).map{ |date| date.to_date }
      data = []
      messages = 0
      dates.each do |date|
        count = Message.validated.where(:created_at => (date..date.tomorrow.to_date)).where(:campaign_id => campaign.id).all.count
        messages += count
        data.push([date.strftime('%Y-%m-%d'), messages])
      end
      
      return data
    end
    
    def generate_stats_for_petition(campaign)
      dates = (campaign.created_at.to_date..Date.today).map{ |date| date.to_date }
      data = []
      petitions = 0
      dates.each do |date|
        count = Petition.validated.where(:created_at => (date..date.tomorrow.to_date)).where(:campaign_id => campaign.id).where(:validated => true).all.count
        petitions += count
        data.push([date.strftime('%Y-%m-%d'), petitions])
      end
      
      return data
    end

    def generate_token
      secure_digest(Time.now, (1..10).map { rand.to_s})[0,29]
    end

    def secure_digest(*args)
      require 'digest/sha1'
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end
 
end
