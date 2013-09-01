FactoryGirl.define do
  sequence :username do |n|
    "username#{n}"
  end

  sequence :email do |n|
    "email#{n}@example.com"
  end

  sequence :full_name do |n|
    "Full name#{n}"
  end

  factory :user do
    email
    username
    password 'password'
    password_confirmation 'password'
    full_name
    location 'Midtjylland'

    factory :therapist do
      after(:build) do |user|
        user.add_role(Role::Therapist)
      end
    end

    factory :admin do
      after(:build) do |user|
        user.add_role(Role::Admin)
      end
    end

    factory :relative do
      after(:build) do |user|
        user.add_role(Role::Relative)
      end
    end

    factory :client do
      after(:build) do |user|
        user.add_role(Role::Client)
      end
    end
  end

  factory :daily_journal do
    sequence :name do |n|
      "name#{n}"
    end
    sequence :description do |n|
      "description#{n}"
    end
    calm true
    angry false
    anxious false
    manic false
    happiness_level 3
  end
end
