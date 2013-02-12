class SendFax < Resque::ThrottledJob

  throttle :can_run_every => 1.minute

  @queue = :faxer

  def self.perform fax_id
    campaign = Fax.find(fax_id).campaign
    campaign.numbers.each do |number|
      if campaign.has_credit?
        Mailman.send_message_to_fax_recipient(fax_id, campaign.id, number).deliver
        campaign.credit -= 1
        campaign.save
      end
    end
  end
end
