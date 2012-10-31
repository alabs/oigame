class ApplicationController < ActionController::Base
  
  helper :all
  
  before_filter :set_locale
  protect_from_forgery

  before_filter { |c| Authorization.current_user = c.current_user }

  def permission_denied
    redirect_to root_url, :alert => 'Sorry, you not allowed to access that page'
  end

  protected

  # Método para decirle a Varnish qué tiene que cachear
  def set_http_cache(period, visibility = false)
    expires_in period, :public => visibility, 'max-stale' => 0
  end
    
  def generate_token
    secure_digest(Time.now, (1..10).map { rand.to_s})[0,29]
  end

  def secure_digest(*args)
    require 'digest/sha1'
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def get_sub_oigame
    unless params[:sub_oigame_id].nil?
      @sub_oigame = SubOigame.find_by_slug params[:sub_oigame_id]
      if @sub_oigame.nil?
        return @sub_oigame = 'not found'
      end
    else
      return @sub_oigame = nil
    end
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
