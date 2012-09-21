# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donation do
    user_id 1
    campaign_id 1
    amount "9.99"
  end
end
