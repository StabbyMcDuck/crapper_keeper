FactoryGirl.define do
  factory :identity do
    oauth_token { SecureRandom.uuid }
    provider "crapper_keeper_http_basic"
    uid { SecureRandom.uuid }
    user
  end
end