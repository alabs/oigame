class ApplicationController < ActionController::Base

  helper :all

  before_filter :set_locale, :header_data, :set_meta_defaults
  protect_from_forgery

  before_filter { |c| Authorization.current_user = c.current_user }

  def permission_denied
    redirect_to root_url, :alert => t(:sorry_you_are_not_allowed)
  end

  if Rails.env.production? or Rails.env.staging?
    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, with: :render_500
      rescue_from ActionController::RoutingError, with: :render_404
      rescue_from ActionController::UnknownController, with: :render_404
      rescue_from ActionController::UnknownAction, with: :render_404
      rescue_from ActiveRecord::RecordNotFound, with: :render_404
    end
  end

  def render_404(exception)
    @not_found_path = exception.message
    respond_to do |format|
      format.html { render template: 'errors/not_found', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500(exception)
    logger.info exception.backtrace.join("\n")
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', layout: 'layouts/application', status: 500 }
      format.all { render nothing: true, status: 500}
    end
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

  def set_layout
    if params[:v] == 'old'
      "old"
    else
      "application"
    end
  end

  def header_data
    # cachear esto con redis
    @total_published_campaigns = Rails.cache.fetch("otpc", :expires_in => 3.hours) { Campaign.total_published_campaigns.all.count }
    @total_signs = Rails.cache.fetch("ots", :expires_in => 3.hours) { (Message.validated.all + Petition.validated.all + Fax.validated.all ).count }
    @total_users = Rails.cache.fetch("otu", :expires_in => 3.hours) { User.all.count }
    @slideshow_campaigns = Rails.cache.fetch("osc", :expires_in => 3.minutes) { Campaign.last_campaigns_without_pagination(4) }
  end

  def set_meta_defaults
    @meta = {} || @meta
    @meta['title'] = 'oiga.me'
    @meta['description'] = 'Participa y colabora'
    @meta['og'] = {} || @meta['og']
    @meta['og']['locale'] = 'es'
    @meta['fb'] = {} || @meta['fb']
    @meta['fb']['app_id'] = APP_CONFIG[:FACEBOOK_APP_ID]
    @meta['oigameapp'] = {} || @meta['oigameapp']
  end
end
