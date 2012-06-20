# encoding: utf-8
class Mailman < ActionMailer::Base

  default :from => "oigame@oiga.me"
  layout "email"
  helper :application

  def send_message_to_user(to, subject, message, campaign)
    @message_to = to
    @message_subject = subject
    @message_body = message
    @campaign = campaign
    subject = "[oiga.me] Última tarea para unirte a la campaña: #{@campaign.name}"
    mail :to => to, :subject => subject
  end

  def send_campaign_to_social_council(campaign)
    @campaign = campaign
    subject = "[oiga.me] #{@campaign.name}"
    mail :to => APP_CONFIG[:social_council_email], :subject => subject
  end

  def send_campaign_to_sub_oigame_admin(sub_oigame, campaign)
    @campaign = campaign
    @sub_oigame = sub_oigame
    subject = "[#{@sub_oigame.name}] #{@campaign.name}"
    mail :to => @sub_oigame.user.email, :subject => subject
  end

  def send_contact_message(message)
    @message = message
    from = "#{@message.name} <#{@message.email}>"
    subject = "[oiga.me] #{@message.subject}"
    @message_body = @message.body
    mail :from => from, :to => 'hola@oiga.me', :subject => subject
  end

  def send_message_to_validate_message(to, campaign, message)
    @campaign = campaign
    @token = message.token
    from = ""
    # TODO: esto que viene no es muy DRY que digamos 
    # seguro que hay alguna forma elegante con un before o alguna cosas de estas
    if defined? campaign.sub_oigame then
      prefix = "[#{campaign.sub_oigame.name}]"
      @sub_oigame = @campaign.sub_oigame
      @url = "#{APP_CONFIG[:domain]}/o/#{@sub_oigame.name}/campaigns/#{@campaign.slug}"
      from = @sub_oigame.from
    else
      prefix = "[oiga.me]"
      @url = "#{APP_CONFIG[:domain]}/campaigns/#{@campaign.slug}"
    end
    subject = "#{prefix} Valida tu adhesion a la campaña: #{@campaign.name}"
    if from.nil?
      from = default[:from]
    end
    mail :from => from, :to => to, :subject => subject
  end

  def send_message_to_validate_petition(to, campaign, petition)
    @campaign = campaign
    @token = petition.token
    from = ""
    if defined? campaign.sub_oigame then
      prefix = "[#{campaign.sub_oigame.name}]"
      @sub_oigame = @campaign.sub_oigame
      @url = "#{APP_CONFIG[:domain]}/o/#{@sub_oigame.name}/campaigns/#{@campaign.slug}"
      from = @sub_oigame.from
    else
      prefix = "[oiga.me]"
      @url = "#{APP_CONFIG[:domain]}/campaigns/#{@campaign.slug}"
    end
    subject = "#{prefix} Valida tu adhesion a la campaña: #{@campaign.name}"
    if from.nil?
      from = default[:from]
    end
    mail :from => from, :to => to, :subject => subject
  end

  def inform_campaign_activated(campaign)
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

  def send_message_to_recipients(message)
    @message_body = message.body
    subject = message.subject
    recipients = message.campaign.emails
    mail :from => message.email, :to => message.email, :subject => subject, :bcc => recipients
  end
end
