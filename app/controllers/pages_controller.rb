class PagesController < ApplicationController

  layout :set_layout

  filter_access_to :all
  filter_access_to :activity

  def index
    @campaigns_carousel = Campaign.last_campaigns_without_pagination(4)
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
        Mailman.send_contact_message(@contact.id).deliver
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

  def about
  end

  def activity
    messages_q = Message.find(:all, :order => "created_at desc", :select => "created_at, name, campaign_id, id", :limit => 8)
    @messages = messages_q.map do |m|
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
      format.json { render json: @messages }
    end
  end

end
