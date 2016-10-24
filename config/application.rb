require_relative 'boot'

require 'rails'

%w(
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  rails/test_unit/railtie
  sprockets/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end
require 'neo4j/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CrapperKeeper
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden

    config.generators { |g| g.orm :neo4j }

    config.neo4j.session_type = :server_db
    config.neo4j.session_path = ENV["GRAPHENEDB_URL"] || 'http://localhost:7474'

  end
end
