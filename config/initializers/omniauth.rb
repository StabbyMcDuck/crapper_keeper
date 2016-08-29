OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1805926139684724', ENV['FACEBOOK_APP_SECRET']
end
