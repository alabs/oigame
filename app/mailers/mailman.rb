# encoding: utf-8
class Mailman < ActionMailer::Base

  include Resque::Mailer # para enviar correos en background

  default :from => "oigame@oiga.me"
  layout "email", :except => :send_message_to_fax_recipients
  helper :application
  include ApplicationHelper

  def send_message_to_user(to, subject, message, campaign_id)
    @message_to = to
    @message_subject = subject
    @message_body = message
    @campaign = Campaign.find(campaign_id)
    subject = "[oiga.me] Última tarea para unirte a la campaña: #{@campaign.name}"
    mail :to => to, :subject => subject
  end

  def send_campaign_to_social_council(campaign_id)
    @campaign = Campaign.find(campaign_id)
    subject = "[oiga.me] #{@campaign.name}"
    mail :to => APP_CONFIG[:social_council_email], :subject => subject
  end

  def send_campaign_to_sub_oigame_admin(sub_oigame_id, campaign_id)
    @campaign = Campaign.find(campaign_id)
    @sub_oigame = SubOigame.find(sub_oigame_id)
    subject = "[#{@sub_oigame.name}] #{@campaign.name}"
    @sub_oigame.users.each do |user|
      mail :to => user.email, :subject => subject
    end
  end

  def send_contact_message(contact_id)
    @message = Contact.find(contact_id)
    from = "#{@message.name} <#{@message.email}>"
    subject = "[oiga.me] #{@message.subject}"
    @message_body = @message.body
    mail :from => from, :to => 'hola@oiga.me', :subject => subject
  end

  def send_message_to_validate_message(to, campaign_id, message_id)
    @campaign = Campaign.find(campaign_id)
    message = Message.find(message_id)
    @token = message.token
    # TODO: esto que viene no es muy DRY que digamos 
    # seguro que hay alguna forma elegante con un before o alguna cosas de estas
    unless @campaign.sub_oigame.nil?
      prefix = "[#{@campaign.sub_oigame.name}]"
      @sub_oigame = @campaign.sub_oigame
      @url = "#{APP_CONFIG[:domain]}/o/#{@sub_oigame.name}/campaigns/#{@campaign.slug}"
    else
      prefix = "[oiga.me]"
      @url = "#{APP_CONFIG[:domain]}/campaigns/#{@campaign.slug}"
    end
    from = generate_from_for_validate('oigame@oiga.me', campaign.sub_oigame)
    subject = "#{prefix} Valida tu adhesion a la campaña: #{@campaign.name}"
    mail :from => from, :to => to, :subject => subject
  end
  
  def send_message_to_validate_fax(to, campaign_id, fax_id)
    @campaign = Campaign.find(campaign_id)
    fax = Fax.find(fax_id)
    @token = fax.token
    # TODO: esto que viene no es muy DRY que digamos 
    # seguro que hay alguna forma elegante con un before o alguna cosas de estas
    unless @campaign.sub_oigame.nil?
      prefix = "[#{@campaign.sub_oigame.name}]"
      @sub_oigame = @campaign.sub_oigame
      @url = "#{APP_CONFIG[:domain]}/o/#{@sub_oigame.name}/campaigns/#{@campaign.slug}"
    else
      prefix = "[oiga.me]"
      @url = "#{APP_CONFIG[:domain]}/campaigns/#{@campaign.slug}"
    end
    from = generate_from_for_validate('oigame@oiga.me', campaign.sub_oigame)
    subject = "#{prefix} Valida tu adhesion a la campaña: #{@campaign.name}"
    mail :from => from, :to => to, :subject => subject
  end

  def send_message_to_validate_petition(to, campaign_id, petition_id)
    @campaign = Campaign.find(campaign_id)
    petition = Petition.find(petition_id)
    @token = petition.token
    from = Mailman.default[:from]
    unless @campaign.sub_oigame.nil?
      prefix = "[#{@campaign.sub_oigame.name}]"
      @sub_oigame = @campaign.sub_oigame
      @url = "#{APP_CONFIG[:domain]}/o/#{@sub_oigame.name}/campaigns/#{@campaign.slug}"
    else
      prefix = "[oiga.me]"
      @url = "#{APP_CONFIG[:domain]}/campaigns/#{@campaign.slug}"
    end
    from = generate_from_for_validate('oigame@oiga.me', campaign.sub_oigame)
    subject = "#{prefix} Valida tu adhesion a la campaña: #{@campaign.name}"
    mail :from => from, :to => to, :subject => subject
  end

  def inform_campaign_activated(campaign_id)
    campaign = Campaign.find(campaign_id)
    @message_to = campaign.user.email
    @campaign_name = campaign.name
    @campaign_slug = campaign.slug
    subject = "[oiga.me] Tu campaña ha sido publicada"
    mail :to => @message_to, :subject => subject
  end

  def send_mailing(email, subject, message)
    @message_body = message
    subject = "[oiga.me] #{subject}"
    mail :to => email, :subject => subject
  end

  def send_message_to_recipients(message_id)
    message = Message.find(message_id)
    @message_body = message.body
    subject = message.subject
    recipients = message.campaign.emails
    mail :from => message.email, :to => message.email, :subject => subject, :bcc => recipients
  end
  
  def send_message_to_fax_recipients(fax_id, campaign_id)
    fax = Fax.find(fax_id)
    campaign = Campaign.find(campaign_id)
    @password = APP_CONFIG[:our_fax_password]
    subject = APP_CONFIG[:our_fax_number]
    fax = FaxPdf.new(fax, campaign)
    attachments['fax.pdf'] = fax.generate_pdf
    numbers = campaign.numbers.map {|number| number + "@ecofax.fr"}
    mail :from => 'fax@oiga.me', :to => numbers, :subject => subject
  end

  def inform_new_comment(campaign_id)
    campaign = Campaign.find(campaign_id)
    @message_to = campaign.user.email
    @campaign_name = campaign.name
    @campaign_slug = campaign.slug
    subject = "[oiga.me] Nuevo mensaje en tu campaña #{ @campaign_name }"
    mail :to => @message_to, :subject => subject
  end
end
