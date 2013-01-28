class SendFax

  @queue = :faxer

  def self.perform fax_id
    campaign = Fax.find(fax_id).campaign
    price = (FaxForRails::TAX * campaign.numbers.size)
    campaign.credit = campaign.credit - price
    campaign.save
    Mailman.send_message_to_fax_recipients(fax_id, campaign.id).deliver
  end
end
