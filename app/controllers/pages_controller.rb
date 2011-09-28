class PagesController < ApplicationController

  def index
    @campaigns = Campaign.last_campaigns(3)
  end

  def donate
  end

  def help
  end

  def privacy_policy
  end
end
