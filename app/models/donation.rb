class Donation < ActiveRecord::Base
  
  belongs_to :campaign
  belongs_to :user

  validates_presence_of :campaign_id
  validates_presence_of :amount

  after_create :add_credit_to_campaign

  protected

  def add_credit_to_campaign
    campaign = self.campaign
    campaign.credit += self.amount
    campaign.save
  end
end
