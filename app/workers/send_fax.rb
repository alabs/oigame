class SendFax

  @queue = :faxer

  def self.perform fax_id
    campaign = Fax.find(fax_id).campaign
    campaign.numbers.each do |number|
      while campaign.has_credit?
        Mailman.send_message_to_fax_recipient(fax_id, campaign.id, number).deliver
      end
    end
    campaign.credit -= campaign.numbers.size
    campaign.save
  end
end
