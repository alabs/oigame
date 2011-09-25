class PagesController < ApplicationController

  def index
    @campaigns = Campaign.last_campaigns(3)
  end

  def testing
    flash[:error] = 'Esto es un mensaje de prueba'
    redirect_to root_path
  end
end
