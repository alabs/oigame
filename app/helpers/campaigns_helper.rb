# encoding: utf-8
module CampaignsHelper

  def process_message
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
              redirect_to message_sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'Gracias por unirte a esta campaña'
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
        redirect_to message_sub_oigame_campaign_url(@sub_oigame, @campaign), :notice => 'Gracias por unirte a esta campaña'
      end

      return
    else
      flash[:error] = "Esta campaña ya no está activa."
      redirect_to campaigns_url
    end
  end

  def process_petition
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
