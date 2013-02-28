# encoding: utf-8
module CampaignsHelper

  def url_for_campaign_form
    # esto es para dar diferentes URLs para el formulario de creacion/propuesta de campañas
    # las variables a tener en cuenta son el tipo de accion (si es new/edit/first/etc) y si es de un sub

    if params[:action] == "new" 
      url = @sub_oigame ? sub_oigame_campaigns_path(@sub_oigame) : campaigns_path 
    end 

    if params[:action] == "edit" 
      url = @sub_oigame ? sub_oigame_campaign_path(@sub_oigame, @campaign) : campaign_path(@campaign) 
    end 

    # TODO wizard#edit#first
    if params[:controller] == "wizard" and params[:action] == "show" and params[:id] == "first"
      url = @sub_oigame ? sub_oigame_campaign_wizard_path(@sub_oigame) : campaign_wizard_path
    end

    if params[:controller] == "wizard" and params[:action] == "show" and params[:id] == "second"
      url = @sub_oigame ? sub_oigame_campaign_wizard_path(@sub_oigame) : campaign_wizard_path
    end

    return url
  end

end
