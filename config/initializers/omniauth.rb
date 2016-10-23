OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1805926139684724', ENV['FACEBOOK_APP_SECRET']
  provider :github, 'ea009c0c310884f465ed', ENV['GITHUB_SECRET']
  if Rails.env.development?
    provider :developer
  end
end
