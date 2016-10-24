module OmniAuth
  module Strategies
    class CrapperKeeperHttpBasic
      include OmniAuth::Strategy

      option :callback_path, "/auth/crapper-keeper-http-basic/callback"

      credentials {
        {
            token: identity.oauth_token
        }
      }

      info {
        {
            name: identity.user.name
        }
      }

      uid {
        identity.uid
      }

      def callback_phase
        return fail!(:invalid_credentials) unless identity
        super
      end

      private

      def identity
        @identity ||= ActionController::HttpAuthentication::Basic.authenticate(
            ActionDispatch::Request.new(request.env)
        ) { |user, password|
          Identity.find_by(oauth_token: password, provider: 'crapper_keeper_http_basic', uid: user)
        }
      end
    end
  end
end