class ErrorsController < ApplicationController

  before_filter :set_locale, :header_data, :set_meta_defaults

  def error_404
    @title = t('oigame.errors.page_not_found')
    @not_found_path = params[:not_found]
  end

  def error_500
  end
end
