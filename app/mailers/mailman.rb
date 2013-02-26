# encoding: utf-8
class Mailman < ActionMailer::Base

  include Resque::Mailer # para enviar correos en background

  default :from => "oigame@oiga.me"
  layout "email", :except => [:send_message_to_fax_recipient, :send_message_to_fax_recipients, :send_contact_message]
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

  [:message, :fax, :petition].each do |meth|
    define_method "send_message_to_validate_#{meth}".to_s do |to, campaign_id, signed_id|
      # FIXME: fix rapido para que envie los correos en spanish
      # TODO: I18n bien (con URLs segun el locale, subject y todo)
      I18n.locale = I18n.default_locale
      sign_model = meth.to_s.capitalize.constantize
      @campaign = Campaign.find(campaign_id)
      petition = sign_model.find(signed_id)
      @token = petition.token

      unless @campaign.sub_oigame.nil?
        prefix = "[#{@campaign.sub_oigame.name}]"
        @sub_oigame = @campaign.sub_oigame
        @url = "#{APP_CONFIG[:domain]}/es/o/#{@sub_oigame.name}/campaigns/#{@campaign.slug}"
      else
        prefix = "[oiga.me]"
        @url = "#{APP_CONFIG[:domain]}/es/campaigns/#{@campaign.slug}"
      end

      from = generate_from_for_validate('oigame@oiga.me', @campaign.sub_oigame)
      subject = "#{prefix} Valida tu adhesion a la campaña: #{@campaign.name}"
      mail :from => from, :to => to, :subject => subject
    end
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
  
  # OVH is the best provider for faxing :)
  def send_message_to_fax_recipients(fax_id, campaign_id)
    fax = Fax.find(fax_id)
    campaign = Campaign.find(campaign_id)
    @password = APP_CONFIG[:our_fax_password]
    subject = APP_CONFIG[:our_fax_number]
    doc = FaxPdf.new(fax, campaign)
    attachments["fax-#{campaign_id}-#{fax_id}.pdf"] = doc.generate_pdf
    number = campaign.numbers.first
    mail :from => APP_CONFIG[:fax_from_email_address], :to => number+"@ecofax.fr", :subject => subject
  end

  def send_message_to_fax_recipient(fax_id, campaign_id)
  end
  
  #def send_message_to_fax_recipient(fax_id, campaign_id, number)
  #  @fax = Fax.find(fax_id)
  #  campaign = Campaign.find(campaign_id)
  #  doc = FaxPdf.new(fax, campaign)
  #  attachments["fax-#{campaign_id}-#{fax_id}.pdf"] = doc.generate_pdf
  #  mail :from => 'hola@alabs.org', :to => number+"@mail2fax.popfax.com", :subject => APP_CONFIG[:popfax_password]
  #end

  def inform_new_comment(campaign_id)
    campaign = Campaign.find(campaign_id)
    @message_to = campaign.user.email
    @campaign_name = campaign.name
    @campaign_slug = campaign.slug
    subject = "[oiga.me] Nuevo mensaje en tu campaña #{ @campaign_name }"
    mail :to => @message_to, :subject => subject
  end

  def send_message_lower_credit(campaign_id)
    @campaign = Campaign.find(campaign_id)
    subject = "[oiga.me] Aviso de crédito bajo"
    mail :to => @campaign.user.email, :subject => subject
  end
end
