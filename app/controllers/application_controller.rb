class ApplicationController < ActionController::Base

  helper :all

  before_filter :set_locale, :header_data, :set_meta_defaults
  protect_from_forgery

  before_filter { |c| Authorization.current_user = c.current_user }

  def permission_denied
    redirect_to root_url, :alert => t(:sorry_you_are_not_allowed)
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  private
  def render_error(status, exception)
    if status == 500
      ExceptionNotifier::Notifier.exception_notification(request.env, exception).deliver
    end
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
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
    @meta['fb'] = {} || @meta['fb']
    @meta['fb']['app_id'] = APP_CONFIG[:FACEBOOK_APP_ID]
    @meta['oigameapp'] = {} || @meta['oigameapp']
  end
end
