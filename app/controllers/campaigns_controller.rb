# encoding: utf-8
class CampaignsController < ApplicationController

  #include Social::Facebook

  before_filter :protect_from_spam, :only => [:message, :petition, :fax]
  protect_from_forgery :except => [:message, :petition, :fax]
  layout 'application', :except => [:widget, :widget_iframe]
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy, :moderated, :activate, :participants, :add_credit]
  
  # comienza la refactorización a muerte
  before_filter :get_sub_oigame
  
  before_filter :get_campaign, :except => [:index, :message, :petition, :fax, :feed, :new, :create, :archived]

  # para declarative_auth
  filter_access_to :all, :attribute_check => true
  # para que no se haga check del attributo
  # preguntar a enrique como hacer esto más dry
  filter_access_to :index, :feed, :search, :moderated, :new, :create, :archived, :petition, :message, :fax

  respond_to :html, :json

  def index
    #if @sub_oigame == 'not found'
    #  render_404
    #  return false
    #end
    @campaigns = Campaign.last_campaigns params[:page], @sub_oigame

    respond_with(@campaigns)
  end

  def show
    # para que funcione el botón de facebook
    @cause = true
    @campaign = Campaign.find(:all, :conditions => {:slug => params[:id], :sub_oigame_id => @sub_oigame}).first

    # metas for facebook
    @meta['title'] = @campaign.name
    @meta['og']['url'] = campaign_url(@campaign,locale:nil)
    @meta['description'] = @campaign.intro
    @meta['og']['type'] = 'oigameapp:campaign'
    @meta['oigameapp']['end_date'] = @campaign.duedate_at.strftime("%Y-%m-%d")

    @participants = @campaign.participants

    @has_participated = @campaign.has_participated?(current_user)

    @stats_data = @campaign.stats
    @image_src = @campaign.image_url.to_s
    @image_file = @campaign.image.file.file
    @description = @campaign.to_html(@campaign.intro).html_safe

    respond_with(@campaign)
  end

  def new
    @campaign = Campaign.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @campaign }
    end
  end

  def edit
    @campaign = Campaign.find_by_slug(params[:id])
    if @campaign.save
      if @sub_oigame
        redirect_url = sub_oigame_campaign_wizard_path(@sub_oigame, @campaign.slug, :first)
      else 
        redirect_url = campaign_wizard_path(@campaign.slug, :first)
      end
      redirect_to redirect_url

      return
    else
      render :action => :new
    end
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
    @campaign = Campaign.new(params[:campaign])
    @campaign.user = current_user
    if @campaign.save
      if @sub_oigame
        @campaign.sub_oigame = @sub_oigame
        redirect_url = sub_oigame_campaign_wizard_path(@sub_oigame, @campaign.slug, :first)
      else 
        redirect_url = campaign_wizard_path(@campaign.slug, :first)
      end
      redirect_to redirect_url

      return
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

  def message
    @campaign = Campaign.find_by_slug(params[:id])
    @campaigns = @campaign.other_campaigns
    if request.post?
      if not user_signed_in?
        # si no esta registrado seteamos las cookies para no volver a preguntar 
        # su nombre y su correo - si esta registrado nos da igual
        cookies[:name] = { :value => params[:name], :expires => 1.year.from_now }
        cookies[:email] = { :value => params[:email], :expires => 1.year.from_now }
      end
      from = user_signed_in? ? current_user.email : params[:email]
      if @campaign
        if params[:own_message] == "1" 
          message = Message.new(:campaign => @campaign, :email => from, :subject => params[:subject], :body => params[:body], :token => generate_token)
          if message.save

            # si está registrado no pedirle confirmación de unión a la campaña
            if user_signed_in?
              message.update_attributes(:validated => true, :token => nil)
              Mailman.send_message_to_recipients(message.id).deliver
              if @sub_oigame.nil?
                #redirect_url = message_campaign_url, :notice => 'Gracias por unirte a esta campaña'
                redirect_url = message_campaign_url
              else
                #redirect_url = message_sub_oigame_campaign_url(@campaign, @sub_oigame), :notice => 'Gracias por unirte a esta campaña'
                redirect_url = message_sub_oigame_campaign_url(@campaign, @sub_oigame)
              end
              session[:fb_sess_campaign] = @campaign.id
              redirect_to facebook_auth_url

              # revisar y mandar al sitio correcto
              #redirect_to redirect_url, :notice => 'Gracias por unirte a esta campaña'

              return
            end
            Mailman.send_message_to_validate_message(from, @campaign.id, message.id).deliver
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
              Mailman.send_message_to_recipients(message.id).deliver
              if @sub_oigame.nil?
                redirect_to message_campaign_url, :notice => 'Gracias por unirte a esta campaña'
              else
                redirect_to message_sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'Gracias por unirte a esta campaña'
              end

              return

            end
            Mailman.send_message_to_validate_message(from, @campaign.id, message.id).deliver
          else
            flash.now[:error] = "No puedes participar más de una vez por campaña"
            render :action => :show
            return
          end
        end
        if @sub_oigame.nil?
          redirect_to message_campaign_url
        else
          redirect_to message_sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'Gracias por unirte a esta campaña'
        end

        return
      else
        flash[:error] = "Esta campaña ya no está activa."
        redirect_to campaigns_url
      end
    else
      @campaign = Campaign.published.find_by_slug(params[:id])
      if @campaign
        @stats_data = @campaign.stats
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
          # si no esta registrado seteamos las cookies para no volver a preguntar 
          # su nombre y su correo - si esta registrado nos da igual
          cookies[:name] = { :value => params[:name], :expires => 1.year.from_now }
          cookies[:email] = { :value => params[:email], :expires => 1.year.from_now }
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
          session[:fb_sess_campaign] = @campaign.id
          redirect_to facebook_auth_url

          # revisar y mandar al sitio correcto
          #redirect_to redirect_url, :notice => 'Gracias por unirte a esta campaña'

          return

        end
        Mailman.send_message_to_validate_petition(to, @campaign.id, @petition.id).deliver
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
    if @campaign
      @campaigns = @campaign.other_campaigns
      model = Message.find_by_token(params[:token]) || Petition.find_by_token(params[:token]) || Fax.find_by_token(params[:token])
      if model
        model.update_attributes(:validated => true, :token => nil)
        case model.class.name
        when 'Message'
          Mailman.send_message_to_recipients(model.id).deliver
        when 'Fax'
          Mailman.send_message_to_fax_recipients(model.id, @campaign.id).deliver
        end
        redirect_to validated_campaign_url, :notice => 'Tu adhesión se ha ejecutado con éxito'

        return
      else
        render
      end
    else
      flash[:notice] = "Esa campaña ya no está activa"
      redirect_to campaigns_url
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
    else
      @campaigns = Campaign.archived_campaigns(params[:page], @sub_oigame)
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
    if params[:q]
      if @sub_oigame.nil?
        # mirar en la deficion de indices lo del no_sub
        @campaigns = Campaign.active.search params[:q], :with => {:no_sub => true }  #, :order => :created_at, :sort => :asc
      else 
        @campaigns = Campaign.active.search params[:q], :conditions => {:sub_oigame_id => @sub_oigame.id}
      end
    end
  end

  #def new_comment
  #  @campaign = Campaign.find(:all, :conditions => {:slug => params[:id], :sub_oigame_id => @sub_oigame}).first
  #  Mailman.inform_new_comment(@campaign).deliver
  #  redirect_to @campaign
  #end
  
  def fax
    @campaign = Campaign.find_by_slug(params[:id])
    @campaigns = @campaign.other_campaigns
    if request.post?
      if user_signed_in?
        if current_user.name.blank?
          current_user.update_attributes(:name => params[:name])
          # si no esta registrado seteamos las cookies para no volver a preguntar 
          # su nombre y su correo - si esta registrado nos da igual
          cookies[:name] = { :value => params[:name], :expires => 1.year.from_now }
          cookies[:email] = { :value => params[:email], :expires => 1.year.from_now }
        end
      end
      from = user_signed_in? ? current_user.email : params[:email]
      if @campaign
        if params[:own_message] == "1" 
          fax = Fax.new(:campaign => @campaign, :name => params[:name], :email => from, :body => params[:body], :token => generate_token)
          if fax.save

            # si está registrado no pedirle confirmación de unión a la campaña
            if user_signed_in?
              fax.update_attributes(:validated => true, :token => nil)
              Mailman.send_message_to_fax_recipients(fax.id, @campaign.id).deliver
              if @sub_oigame.nil?
                #redirect_url = fax_campaign_url, :notice => 'Gracias por unirte a esta campaña'
                redirect_url = fax_campaign_url
              else
                #redirect_url = fax_sub_oigame_campaign_url(@campaign, @sub_oigame), :notice => 'Gracias por unirte a esta campaña'
                redirect_url = fax_sub_oigame_campaign_url(@campaign, @sub_oigame)
              end
              session[:fb_sess_campaign] = @campaign.id
              redirect_to facebook_auth_url

              # revisar y mandar al sitio correcto
              #redirect_to redirect_url, :notice => 'Gracias por unirte a esta campaña'
              return
            end
            Mailman.send_message_to_validate_fax(from, @campaign.id, fax.id).deliver
          else
            flash.now[:error] = "No puedes participar más de una vez por campaña"
            render :action => :show
            return
          end
        else
          # mensaje por defecto
          fax = Fax.new(:campaign => @campaign, :name => params[:name], :email => from, :body => @campaign.default_message_body, :token => generate_token)
          if fax.save
            # si está registrado no pedirle confirmación de unión a la campaña
            if user_signed_in?
              fax.update_attributes(:validated => true, :token => nil)
              Mailman.send_message_to_fax_recipients(fax.id, @campaign.id).deliver
              if @sub_oigame.nil?
                redirect_to fax_campaign_url, :notice => 'Gracias por unirte a esta campaña'
              else
                redirect_to fax_sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'Gracias por unirte a esta campaña'
              end

              return

            end
            Mailman.send_message_to_validate_fax(from, @campaign.id, fax.id).deliver
          else
            flash.now[:error] = "No puedes participar más de una vez por campaña"
            render :action => :show
            return
          end
        end
        if @sub_oigame.nil?
          redirect_to fax_campaign_url
        else
          redirect_to fax_sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'Gracias por unirte a esta campaña'
        end

        return
      else
        flash[:error] = "Esta campaña ya no está activa."
        redirect_to campaigns_url
      end
    else
      @campaign = Campaign.published.find_by_slug(params[:id])
      if @campaign
        @stats_data = @campaign.stats
      else
        flash[:error] = "Esta campaña ya no está activa."
        redirect_to campaigns_url
      end
    end
  end

  def add_credit
    unless current_user.ready_for_add_credit
      session[:redirect_to_add_credit] = "#{APP_CONFIG[:domain]}/campaigns/#{@campaign.slug}/add-credit"
      flash[:error] = 'Necesitamos que nos digas tu nombre para poder añadir crédito'
      redirect_to edit_user_registration_url

      return
    end

    @reference = secure_digest(Time.now, (1..10).map { rand.to_s})[0,29]
    
    data = {}
    data[:reference] = @reference
    data[:name] = current_user.name
    data[:email] = current_user.email
    data[:cback] = campaign_url(@campaign)
    HTTParty.post("http://#{APP_CONFIG[:gw_domain]}/pre", :body => data)
  end

  private

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => nil }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def get_campaign
    @campaign = Campaign.find_by_slug(params[:id])
  end
end
