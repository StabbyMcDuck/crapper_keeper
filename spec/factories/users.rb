FactoryGirl.define do
  factory :user do
    uid { generate(:user_uid) }
  end

  sequence(:user_uid) { |n|
    n
  }
end