class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  # Método para decirle a Varnish qué tiene que cachear
  def set_http_cache(period, visibility)
    expires_in period, :public => visibility, 'max-stale' => 0
  end
end
