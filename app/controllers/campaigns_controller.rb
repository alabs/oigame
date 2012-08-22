# encoding: utf-8
class CampaignsController < ApplicationController

  before_filter :protect_from_spam, :only => [:message, :petition]
  protect_from_forgery :except => [:message, :petition]
  layout 'application', :except => [:widget, :widget_iframe]
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy, :moderated, :activate, :participants]
  
  # comienza la refactorización a muerte
  before_filter :get_sub_oigame

  # para cancan
  load_resource :find_by => :slug
  skip_load_resource :only => [:index, :tag, :tags_archived, :message, :moderated, :feed, :archived]
  authorize_resource
  skip_authorize_resource :only => [:index, :tag, :tags_archived, :message, :feed, :integrate]

  respond_to :html, :json

  def index
    if @sub_oigame == 'not found'
      render_404
      return false
    end
    @campaigns = Campaign.last_campaigns params[:page], @sub_oigame
    if @sub_oigame.nil? 
      @tags = Rails.cache.fetch('tags_campaigns_index_no_sub', :expires_in => 3.hours) { Campaign.where(:sub_oigame_id => nil).published.tag_counts_on(:tags) }
    else
      @tags = Rails.cache.fetch("tags_campaigns_index_with_sub_#{@sub_oigame.id}", :expires_in => 3.hours) { Campaign.where(:sub_oigame_id => @sub_oigame).published.tag_counts_on(:tags) }
    end

    respond_with(@campaigns)
  end

  def show
    # para que funcione el botón de facebook
    @cause = true
    @campaign = Campaign.find(:all, :conditions => {:slug => params[:id], :sub_oigame_id => @sub_oigame}).first

    if @campaign.nil?
      render_404 
      return false
    end

    @participants = @campaign.participants

    # comprobamos si este usuario ya ha participado en este campaña
    if defined? current_user.email
      participants_emails = @participants.map {|x| x.email}
      if participants_emails.include? current_user.email
        @has_participated = true
      else
        @has_participated = false
      end
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

    respond_with(@campaign)
  end

  def new
  end

  def edit
  end

  def participants
    # Descarga un fichero con el listado de participantes
    #
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
      if @sub_oigame
        redirect_to sub_oigame_campaign_url(@sub_oigame, @campaign)
      else
        redirect_to @campaign
      end
    else
      render :action => :edit
    end
  end

  def destroy
    @campaign.destroy
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
    @campaigns = Campaign.last_campaigns_by_tag(params[:id], params[:page])

    if @sub_oigame.nil?
      @tags = Rails.cache.fetch('tags_campaigns_index_no_sub', :expires_in => 3.hours) { Campaign.where(:sub_oigame_id => nil).published.tag_counts_on(:tags) }
    else
      @tags = Rails.cache.fetch("tags_campaigns_index_with_sub_#{@sub_oigame.id}", :expires_in => 3.hours) { Campaign.where(:sub_oigame_id => @sub_oigame).published.tag_counts_on(:tags) }
    end
  end

  def tags_archived
    @archived = true

    if @sub_oigame.nil?
      @campaigns = Campaign.last_campaigns_by_tag_archived(params[:id], params[:page])
      @tags = Rails.cache.fetch("tags_campaigns_tags_archived_no_sub", :expires => 3.hours) { Campaign.where(:sub_oigame_id => nil).on_archive.tag_counts_on(:tags) }
    else
      @campaigns = Campaign.last_campaigns_by_tag_archived(params[:id], params[:page], @sub_oigame)
      @tags = Rails.cache.fetch("tags_campaigns_tags_archived_with_sub", :expires_in => 3.hours) { Campaign.by_sub_oigame(@sub_oigame).on_archive.tag_counts_on(:tags) }
    end
  end

  def message
    @campaign = Campaign.find_by_slug(params[:id])
    @campaigns = @campaign.other_campaigns
    if request.post?
      from = user_signed_in? ? current_user.email : params[:email]
      if @campaign
        if params[:own_message] == "1" 
          message = Message.new(:campaign => @campaign, :email => from, :subject => params[:subject], :body => params[:body], :token => generate_token)
          if message.save
            # TODO: vamos a setearle al usuario anonimo una cookie con que ya ha participado de esta campaña 
            # cookies["camp_" + @campaign.id] = "has_participated"
            # esto se comprueba en el show de la camapaña, para mostrarle el has_participated

            # si está registrado no pedirle confirmación de unión a la campaña
            if user_signed_in?
              message.update_attributes(:validated => true, :token => nil)
              if @sub_oigame.nil?
                redirect_to message_campaign_url, :notice => 'Gracias por unirte a esta campaña'
              else
                redirect_to message_sub_oigame_campaign_url(@campaign, @sub_oigame), :notice => 'Gracias por unirte a esta campaña'
              end

              return

            end
            Mailman.send_message_to_validate_message(from, @campaign, message).deliver
          else
            flash.now[:error] = "No puedes participar más de una vez por campaña"
            render :action => :show
            return
          end
        else
          # mensaje por defecto
          message = Message.new(:campaign => @campaign, :email => from, :subject => @campaign.default_message_subject, :body => @campaign.default_message_body, :token => generate_token)
          if message.save
            # si está registrado no pedirle confirmación de unión a la campaña
            if user_signed_in?
              message.update_attributes(:validated => true, :token => nil)
              if @sub_oigame.nil?
                redirect_to message_campaign_url, :notice => 'Gracias por unirte a esta campaña'
              else
                redirect_to message_sub_oigame_campaign_url(@campaign, @sub_oigame), :notice => 'Gracias por unirte a esta campaña'
              end

              return

            end
            Mailman.send_message_to_validate_message(from, @campaign, message).deliver
          else
            flash.now[:error] = "No puedes participar más de una vez por campaña"
            render :action => :show
            return
          end
        end
        if @sub_oigame.nil?
          redirect_to message_campaign_url
        else
          redirect_to message_sub_oigame_campaign_url(@campaign, @sub_oigame), :notice => 'Gracias por unirte a esta campaña'
        end

        return
      else
        flash[:error] = "Esta campaña ya no está activa."
        redirect_to campaigns_url
      end
    else
      @campaign = Campaign.published.find_by_slug(params[:id])
      if @campaign
        @stats_data = generate_stats_for_mailing(@campaign)
      else
        flash[:error] = "Esta campaña ya no está activa."
        redirect_to campaigns_url
      end
    end
  end

  def petition
    @campaign = Campaign.find_by_slug(params[:id])
    @campaigns = @campaign.other_campaigns
    if request.post?
      if user_signed_in?
        if current_user.name.blank?
          current_user.update_attributes(:name => params[:name])
        end
      end
      to = user_signed_in? ? current_user.email : params[:email]
      @petition = Petition.new(:campaign => @campaign, :name => params[:name], :email => to, :token => generate_token )
      if @petition.save
        # si está registado no enviar mensaje de confirmación
        if user_signed_in?
          @petition.update_attributes(:validated => true, :token => nil)
          if @sub_oigame
            redirect_url = petition_sub_oigame_campaign_url
          else
            redirect_url = petition_campaign_url
          end
          redirect_to redirect_url, :notice => 'Gracias por unirte a esta campaña'

          return

        end
        Mailman.send_message_to_validate_petition(to, @campaign, @petition).deliver
        if @sub_oigame
          redirect_url = petition_sub_oigame_campaign_url
        else
          redirect_url = petition_campaign_url
        end
        redirect_to redirect_url, :notice => 'Gracias por unirte a esta campaña'
      else
        flash.now[:error] = 'No puedes participar más de una vez por campaña'
        render :action => :show 
      end
    end
  end

  def validate
    @campaign = Campaign.published.find_by_slug(params[:id])
    @campaigns = @campaign.other_campaigns
    model = Message.find_by_token(params[:token]) || Petition.find_by_token(params[:token])
    if model
      model.update_attributes(:validated => true, :token => nil)
      # Enviar el mensaje si model es Message
      if model.class.name == 'Message'
        Mailman.send_message_to_recipients(model).deliver
      end
      redirect_to validated_campaign_url, :notice => 'Tu adhesión se ha ejecutado con éxito'

      return
    else
      render
    end
  end

  def integrate
  end
  
  def validated
    @campaign = Campaign.find(:all, :conditions => {:slug => params[:id]}).first
    @campaigns = @campaign.other_campaigns
  end

  def moderated
    @campaigns = Campaign.last_campaigns_moderated params[:page], @sub_oigame
    if @sub_oigame.nil? 
      @tags = Campaign.where(:sub_oigame_id => nil).published.tag_counts_on(:tags)
    else
      @tags = Campaign.where(:sub_oigame_id => @sub_oigame).published.tag_counts_on(:tags)
    end
  end

  def activate
    @campaign.activate!

    if @sub_oigame.nil? 
      redirect_to @campaign, :notice => 'La campaña se ha activado con éxito'
    else
      redirect_to sub_oigame_campaign_url( @sub_oigame, @campaign ), :notice => 'La campaña se ha activado con éxito'
    end
  end

  def deactivate
    @campaign.deactivate!

    if @sub_oigame.nil? 
      redirect_to @campaign, :notice => 'Campaña desactivada con éxito'
    else
      redirect_to sub_oigame_campaign_url( @sub_oigame, @campaign ), :notice => 'Campaña desactivada con éxito'
    end
  end

  def feed
    @campaigns = Campaign.last_campaigns_without_pagination(10)

    set_http_cache(3.hours, visibility = true)

    respond_to do |format|
      format.rss # feed.rss.builder
      format.json { render json: @campaigns }
    end
  end

  def archive
    @campaign.archive
    if @sub_oigame.nil?
      redirect_to @campaign, :notice => 'La campaña ha sido archivada con éxito'
    else
      redirect_to sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'La campaña ha sido archivada con éxito'
    end
  end

  def archived
    @archived = true

    if @sub_oigame.nil?
      @campaigns = Campaign.archived_campaigns params[:page]
      @tags = Rails.cache.fetch("tags_campaigns_tags_archived_no_sub", :expires_in => 3.hours) { Campaign.where(:sub_oigame_id => nil).on_archive.tag_counts_on(:tags) }
    else
      @campaigns = Campaign.archived_campaigns(params[:page], @sub_oigame)
      @tags = Rails.cache.fetch("tags_campaigns_tags_archived_with_sub", :expires_in => 3.hours) { Campaign.by_sub_oigame(@sub_oigame).on_archive.tag_counts_on(:tags) }
    end
  end

  def prioritize
    @campaign.priority = true
    @campaign.save!
    if @sub_oigame.nil?
      redirect_to @campaign, :notice => 'La campaña ha sido marcada con prioridad'
    else
      redirect_to sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'La campaña ha sido marcada con prioridad'
    end
  end

  def deprioritize
    @campaign.priority = false
    @campaign.save!
    if @sub_oigame.nil?
      redirect_to @campaign, :notice => 'La campaña ha sido desmarcada con prioridad'
    else
      redirect_to sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'La campaña ha sido desmarcada con prioridad'
    end
  end

  def search
    if @sub_oigame.nil?
      # mirar en la deficion de indices lo del no_sub
      @campaigns = Campaign.active.search params[:q], :with => {:no_sub => true }  #, :order => :created_at, :sort => :asc
    else 
      @campaigns = Campaign.active.search params[:q], :conditions => {:sub_oigame_id => @sub_oigame.id}
    end
  end

  private

    def get_sub_oigame
      unless params[:sub_oigame_id].nil?
        @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
        if @sub_oigame.nil?
          return @sub_oigame = 'not found'
        end
      else
        return @sub_oigame = nil
      end
    end

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
