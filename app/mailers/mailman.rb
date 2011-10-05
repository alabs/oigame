# encoding: utf-8
class Mailman < ActionMailer::Base

  default from: "noreply@oiga.me"

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
end
