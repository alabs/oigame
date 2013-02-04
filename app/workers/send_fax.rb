class SendFax

  @queue = :faxer

  def self.perform fax_id
    campaign = Fax.find(fax_id).campaign
    campaign.credit -= campaign.numbers.size
    campaign.save
    Mailman.send_message_to_fax_recipients(fax_id, campaign.id).deliver
  end
end
