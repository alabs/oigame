class SendFax < Resque::ThrottledJob

  throttle :can_run_every => 1.minute

  @queue = :faxer

  def self.perform fax_id
    campaign = Fax.find(fax_id).campaign
    credits = campaign.numbers.size
    if campaign.has_credit?(credits)
      Mailman.send_message_to_fax_recipient(fax_id, campaign.id).deliver
      campaign.credit -= credits
      campaign.save
    end
  end
end
