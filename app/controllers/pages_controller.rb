class PagesController < ApplicationController

  layout 'main'

  def index
  end

  def testing
    flash[:error] = 'Esto es un mensaje de prueba'
    redirect_to root_path
  end
end
