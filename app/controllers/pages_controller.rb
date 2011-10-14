class PagesController < ApplicationController

  def index
    #@campaigns = Campaign.last_campaigns(3)
    #@users = User.count
  end

  def answers
  end

  def privacy_policy
  end
  
  def donate
    @reference = secure_digest(Time.now, (1..10).map { rand.to_s})[0,29]

    data = {}
    data[:reference] = @reference
    HTTParty.post("http://#{APP_CONFIG[:gw_domain]}/pre", :body => data)
  end

  def donation_accepted
  end

  def donation_denied
  end

  def contact
    if request.post?
      @contact = Contact.new(params[:contact])
      if @contact.save
        Mailman.send_contact_message(@contact).deliver
        redirect_to contact_received_path, :notice => 'Mensaje recibido, pronto nos pondremos en contacto'

        return
      else
        render
      end
    else
      @contact = Contact.new
    end
  end

  def contact_received
  end

  private
  
  def secure_digest(*args)
    require 'digest/sha1'
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
end
