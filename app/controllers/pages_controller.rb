class PagesController < ApplicationController

  def index
    @campaigns = Campaign.last_campaigns(3)
    #@users = User.count
    set_http_cache(3.hours)
  end

  def answers
    set_http_cache(12.hours)
  end

  def privacy_policy
    set_http_cache(24.hours)
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
      set_http_cache(24.hours)
    end
  end

  def contact_received
    set_http_cache(24.hours)
  end
end
