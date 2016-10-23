FactoryGirl.define do
  factory :container do
    description { Faker::Hipster.paragraph }
    name { Faker::Commerce.product_name }
    user
  end


end