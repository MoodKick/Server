# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content_object do
    sequence(:title) { |n| "title#{n}" }
    sequence(:name) { |n| "name#{n}" }
    sequence(:author) { |n| "author#{n}" }
    sequence(:description) { |n| "description#{n}" }
  end
end
