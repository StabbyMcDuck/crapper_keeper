FactoryGirl.define do
  factory :container do
    uid { generate(:container_cid) }
  end

  sequence(:container_cid) { |n|
    n
  }
end