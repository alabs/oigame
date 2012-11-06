class FaxStressWorker

  @queue = :fax_stress_worker

  def self.perform(fax_id)
    fax = Fax.find(fax_id)
    campaign = fax.campaign
    1.upto(100) do |i|
      Mailman.send_message_to_fax_recipients(fax, campaign).deliver
    end
  end
end
