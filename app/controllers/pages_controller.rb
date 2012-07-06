class PagesController < ApplicationController

  def index
    @campaigns = Campaign.last_campaigns_for_home(3)
    @users = User.count
    @users += Message.validated.count
    @users += Petition.validated.count
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
end
