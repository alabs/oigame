class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  # Método para decirle a Varnish qué tiene que cachear
  def set_http_cache(period, visibility = false)
    expires_in period, :public => visibility, 'max-stale' => 0
  end

  private

    def sub_oigame_layout
      # Si en la url hay un sub_oigame definido entonces le pasamos el layout de sub_oigame
      # es el mismo layout que application pero tambien tiene el header/footer/estilos del sub
      # hacemos tambien accesible al objeto @sub_oigame
      @sub_oigame_exists = SubOigame.find_by_slug(params[:sub_oigame_id])
      if @sub_oigame_exists
        return "sub_oigame"
      else 
        return "application"
      end
    end
end
