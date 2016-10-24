FactoryGirl.define do
  factory :user do
    name { Faker::Superhero.name }
  end
end