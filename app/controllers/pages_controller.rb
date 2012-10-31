class PagesController < ApplicationController

  filter_access_to :all

  def index
    @campaigns = Campaign.last_campaigns_without_pagination(3)
    @users = User.count
    @users += Message.validated.count
    @users += Petition.validated.count
    @users += Fax.validated.count
  end

  def help
  end

  def tutorial
  end

  def privacy_policy
  end
  
  def contact
    if request.post?
      @contact = Contact.new(params[:contact])
      if @contact.save
        Mailman.send_contact_message(@contact).deliver
        redirect_to contact_received_url, :notice => 'Mensaje recibido, pronto nos pondremos en contacto'

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
end
