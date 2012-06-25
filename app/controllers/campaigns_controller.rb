# encoding: utf-8
class CampaignsController < ApplicationController

  before_filter :protect_from_spam, :only => [:message, :petition]
  protect_from_forgery :except => [:message, :petition]
  layout 'application', :except => [:widget, :widget_iframe]
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy, :moderated, :activate, :participants]

  # para cancan
  load_resource :find_by => :slug
  skip_load_resource :only => [:index, :tag, :tags_archived, :message, :moderated, :feed, :archived]
  authorize_resource
  skip_authorize_resource :only => [:index, :tag, :tags_archived, :message, :feed, :integrate]

  def index
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]

    if @sub_oigame.nil? 
      # si no es de un suboigame
      @campaigns = Campaign.where(:sub_oigame_id => nil).includes(:messages, :petitions).last_campaigns
      @tags = Rails.cache.fetch('tags_campaigns_index_no_sub', :expires_in => 3.hours) { Campaign.where(:sub_oigame_id => nil).published.tag_counts_on(:tags) }
    else
      # si es de un suboigame
      @campaigns = Campaign.where(:sub_oigame_id => @sub_oigame).includes(:messages, :petitions).last_campaigns
      @tags = Rails.cache.fetch("tags_campaigns_index_with_sub_#{@sub_oigame.id}", :expires_in => 3.hours) { Campaign.where(:sub_oigame_id => @sub_oigame).published.tag_counts_on(:tags) }
    end
  end

  def show
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    # para que funcione el botón de facebook
    @cause = true
    if @sub_oigame
      @campaign = Campaign.find(:all, :conditions => {:slug => params[:id], :sub_oigame_id => @sub_oigame.id}).first
    else
      @campaign = Campaign.find(:all, :conditions => {:slug => params[:id], :sub_oigame_id => nil}).first
    end

    if @campaign.nil?
      render_404 
      return false
    end

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
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
  end

  def participants
    # Descarga un fichero con el listado de participantes
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    # para que funcione el botón de facebook
    @cause = true
    if @sub_oigame
      @campaign = Campaign.find(:all, :conditions => {:slug => params[:id], :sub_oigame_id => @sub_oigame.id}).first
    else
      @campaign = Campaign.find(:all, :conditions => {:slug => params[:id], :sub_oigame_id => nil}).first
    end
    recipients = @campaign.messages.map {|m| m.email}.sort.uniq
    file = @campaign.name.strip.gsub(" ", "_")
    response = ""
    recipients.each {|r| response += r + "\n" }
    send_data response, :type => "text/plain", 
      :filename=>"#{file}.txt", :disposition => 'attachment'
  end

  def create
    @campaign.user = current_user
    @campaign.target = @campaign.target.gsub(/\./, '')
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    if @sub_oigame
      @campaign.sub_oigame = @sub_oigame
      redirect_url = sub_oigame_campaigns_url(@sub_oigame)
    else 
      redirect_url = campaigns_url 
    end
    if @campaign.save
      if @sub_oigame
        Mailman.send_campaign_to_sub_oigame_admin(@sub_oigame, @campaign).deliver
      else
        Mailman.send_campaign_to_social_council(@campaign).deliver
      end
      flash[:notice] = 'Tu campaña se ha creado con éxito y está pendiente de moderación.'
      redirect_to redirect_url
    else
      render :action => :new
    end
  end

  def update
    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = 'La campaña fué actualizada con éxito.'
      @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
      if @sub_oigame
        redirect_to sub_oigame_campaign_path(@sub_oigame, @campaign)
      else
        redirect_to @campaign
      end
    else
      render :action => :edit
    end
  end

  def destroy
    @campaign.destroy
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    flash[:notice] = 'La campaña se eliminió con éxito'
    if @sub_oigame.nil?
      redirect_to campaigns_url
    else
      redirect_to sub_oigame_campaigns_url(@sub_oigame)
    end
  end

  def widget
  end

  def widget_iframe
    render :partial => "widget_iframe"
  end

  def tag
    @campaigns = Campaign.last_campaigns_by_tag(params[:id])
    @tags = Rails.cache.fetch('tags_campaigns_index_no_sub', :expires_in => 3.hours) { Campaign.where(:sub_oigame_id => nil).published.tag_counts_on(:tags) }
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
        if params[:own_message] == "1" 
          message = Message.create(:campaign => campaign, :email => from, :subject => params[:subject], :body => params[:body], :token => generate_token)
          Mailman.send_message_to_validate_message(from, campaign, message).deliver
        else
          # mensaje por defecto
          message = Message.create(:campaign => campaign, :email => from, :subject => campaign.default_message_subject, :body => campaign.default_message_body, :token => generate_token)
          Mailman.send_message_to_validate_message(from, campaign, message).deliver
        end
        @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
        if @sub_oigame.nil?
          redirect_to message_campaign_path
        else
          redirect_to message_sub_oigame_campaign_path(@campaign, @sub_oigame), :notice => 'Gracias por unirte a esta campaña'
        end

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
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
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
      if @sub_oigame
        redirect_url = petition_sub_oigame_campaign_path
      else
        redirect_url = petition_campaign_path
      end
      redirect_to redirect_url, :notice => 'Gracias por unirte a esta campaña'

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

  def integrate
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
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]

    if @sub_oigame.nil? 
      redirect_to @campaign, :notice => 'La campaña se ha activado con éxito'
    else
      redirect_to sub_oigame_campaign_path( @sub_oigame, @campaign ), :notice => 'La campaña se ha activado con éxito'
    end
  end

  def deactivate
    @campaign.deactivate!

    if @sub_oigame.nil? 
      redirect_to @campaign, :notice => 'Campaña desactivada con éxito'
    else
      redirect_to sub_oigame_campaign_path( @sub_oigame, @campaign ), :notice => 'Campaña desactivada con éxito'
    end
  end

  def feed
    @campaigns = Campaign.last_campaigns(10)
    set_http_cache(3.hours, visibility = true)
  end

  def archive
    @campaign.archive
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    if @sub_oigame.nil?
      redirect_to @campaign, :notice => 'La campaña ha sido archivada con éxito'
    else
      redirect_to sub_oigame_campaign_path(@sub_oigame, @campaign), :notice => 'La campaña ha sido archivada con éxito'
    end
  end

  def archived
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    @archived = true
    @campaigns = Campaign.archived_campaigns
    @tags = Campaign.archived.tag_counts_on(:tags)
  end

  def prioritize
    @campaign.priority = true
    @campaign.save!
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    if @sub_oigame.nil?
      redirect_to @campaign, :notice => 'La campaña ha sido marcada con prioridad'
    else
      redirect_to sub_oigame_campaign_path(@sub_oigame, @campaign), :notice => 'La campaña ha sido marcada con prioridad'
    end
  end

  def deprioritize
    @campaign.priority = false
    @campaign.save!
    @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
    if @sub_oigame.nil?
      redirect_to @campaign, :notice => 'La campaña ha sido desmarcada con prioridad'
    else
      redirect_to sub_oigame_campaign_path(@sub_oigame, @campaign), :notice => 'La campaña ha sido desmarcada con prioridad'
    end
  end

  private

    def generate_stats_for_mailing(campaign)
      dates = (campaign.created_at.to_date..Date.today).map{ |date| date.to_date }
      data = []
      messages = 0
      require Rails.root.to_s+'/app/models/message'
      dates.each do |date|
        count = Rails.cache.fetch("s4m_#{campaign.id}_#{date.to_s}", :expires_in => 3.hour) { Message.validated.where("created_at BETWEEN ? AND ?", date, date.tomorrow.to_date).where(:campaign_id => campaign.id).all }.count
        messages += count
        data.push([date.strftime('%Y-%m-%d'), messages])
      end
      
      return data
    end
    
    def generate_stats_for_petition(campaign)
      dates = (campaign.created_at.to_date..Date.today).map{ |date| date.to_date }
      data = []
      petitions = 0
      require Rails.root.to_s+'/app/models/petition'
      dates.each do |date|
        count = Rails.cache.fetch("s4p_#{campaign.id}_#{date.to_s}", :expires_in => 3.hour) { Petition.validated.where("created_at BETWEEN ? AND ?", date, date.tomorrow.to_date).where(:campaign_id => campaign.id).all }.count
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

    def render_404
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => nil }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    end

 
end
