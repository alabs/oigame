class WizardController < ApplicationController

  layout 'application'

  # para el wizard de creación de campaña
  include Wicked::Wizard

  steps :first, :second

  def show
    @campaign = Campaign.new
    render_wizard
  end
end
