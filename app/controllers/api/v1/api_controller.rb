class API::V1::APIController < ActionController::Base
  include Pundit

  append_view_path(File.join(Rails.root, 'app/views/api/v1'))

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  private
  def authenticate
    request_http_basic_authentication unless identity
  end

  def identity
    @identity ||= authenticate_with_http_basic { |user, password|
      Identity.find_by(oauth_token: password, provider: 'crapper_keeper_http_basic', uid: user)
    }
  end

  def current_user
    @current_user ||= identity.user
  end
  helper_method :current_user

end
