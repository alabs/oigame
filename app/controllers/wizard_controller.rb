class WizardController < ApplicationController

  layout 'application'

  # para el wizard de creación de campaña
  include Wicked::Wizard

  steps :first, :second

  def show
    @campaign = Campaign.new
    render_wizard
  end

  def update
    @campaign = Campaign.new
    case step
    when :first
      @campaign.update_attributes(params[:campaign])
    end
    render_wizard @campaign
  end
end
