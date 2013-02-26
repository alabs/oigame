class SendFax

  @queue = :faxer

  def self.perform fax_id
    campaign = Fax.find(fax_id).campaign
    credits = campaign.numbers.size
    if campaign.has_credit?(credits)
      unless campaign.numbers.size == 1
        Mailman.send_message_to_fax_recipients(fax_id, campaign.id).deliver
      else
        Mailman.send_message_to_fax_recipient(fax_id, campsign.id).deliver
      end
      campaign.credit -= credits
      campaign.save
    else
      # informar que no puede participar gente
      Mailman.send_message_lower_credit(campaign.id).deliver
      campaign.informed_low_credit = true
      campaign.save
    end
  end
end
