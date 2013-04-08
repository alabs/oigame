class PagesController < ApplicationController

  layout :set_layout

  filter_access_to :all
  filter_access_to :activity

  def index
    @campaigns_carousel = Campaign.last_campaigns_without_pagination(6)
    @tweets = Tweet.last_messages('home', 1)
  end

  def press
  end

  def faq
  end

  def tutorial
  end

  def privacy_policy
  end
  
  def contact
    if request.post?
      if verify_recaptcha()
        @contact = Contact.new(params[:contact])
        if @contact.save
          Mailman.send_contact_message(@contact.id).deliver
          redirect_to contact_received_url, :notice => t('oigame.contact.received')
          return
        else
          flash[:error] = "Hubo un error al enviar el mensaje"
          @contact = Contact.new
        end
      else
        @contact = Contact.new
      end
    else
      @contact = Contact.new
    end
  end

  def contact_received
  end

  def about
  end

  def activity
    actions_q = (Petition.last_petitions + Message.last_messages + Fax.last_faxes).sort_by(&:created_at).reverse.first(10)
    @actions = actions_q.map do |m|
      camp = Campaign.find(m.campaign_id)
      {
        :id        => m.id,
        :camp_name => camp.name,
        :camp_url  => camp.get_absolute_url,
        :camp_img  => camp.image_url(:thumb),
        :part_name => m.name ? m.name : "Anon",
        :timestamp => m.created_at.to_i,
      }
    end

    respond_to do |format|
      format.json { render json: @actions }
    end
  end
end
