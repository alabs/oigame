class PagesController < ApplicationController

  def index
    @campaigns = Campaign.last_campaigns(3)
    @users = User.count
  end

  def answers
  end

  def privacy_policy
  end
  
  def donate
    @reference = secure_digest(Time.now, (1..10).map { rand.to_s})[0,29]
  end

  def donation_accepted
  end

  def donation_denied
  end

  private
  
  def secure_digest(*args)
    require 'digest/sha1'
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
end
