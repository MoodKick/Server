# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :safety_plan do
    client_id 1
    therepist_id 1
    body "MyText"
  end
end
