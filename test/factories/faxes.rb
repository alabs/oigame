# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :faxis, :class => 'Fax' do
    campaign_id 1
    email "MyString"
    validated false
    token "MyString"
    name "MyString"
  end
end
