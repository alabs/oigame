# encoding: utf-8
class WizardController < ApplicationController

  layout 'application'

  # para el wizard de creación de campaña
  include Wicked::Wizard

  steps :second

  def show
    @campaign = Campaign.find(session[:campaign_id])
    render_wizard
  end

  def update
    @campaign = Campaign.find(session[:campaign_id])
    @campaign.update_attributes params[:campaign]
    render_wizard @campaign
  end

  def create
    @campaign = Campaign.create
    redirect_to new_campaign_path(:campaign_id => @campaign.id)
  end

  private

  def redirect_to_finish_wizard
    redirect_to root_url, notice: "Gracias por crear la campaña."
  end
end
