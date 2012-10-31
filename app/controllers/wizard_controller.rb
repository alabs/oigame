class WizardController < ApplicationController

  # para el wizard de creación de campaña
  include Wicked::Wizard

  def show
    render_wizard
  end
end
