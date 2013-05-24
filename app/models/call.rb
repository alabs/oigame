class Call < ActiveRecord::Base
  attr_accessible :campaign, :number

  belongs_to :campaign, :counter_cache => true

  def to_s
    self.campaign.name + ": " + self.number
  end

  scope :validated, where(:number, true)

end
