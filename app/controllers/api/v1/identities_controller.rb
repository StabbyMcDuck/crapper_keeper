class API::V1::IdentitiesController < API::V1::APIController
  APP_ID = "1805926139684724"

  # POST /api/v1/identities
  def create
    skip_authorization

    if valid_access_token?(access_token: identity_params["access_token"], provider: identity_params["provider"])
      omniauth = access_token_to_omniauth(
          access_token: identity_params[:access_token],
          provider: identity_params[:provider]
      )

      provider_identity = Identity.find_or_create_with_omniauth(omniauth)

      if provider_identity.provider.present? && provider_identity.uid.present?
        Identity.ensure_user(auth: omniauth, identity: provider_identity)

        api_identity = Identity.find_or_create_by(
            user_id: provider_identity.user.id,
            provider: 'crapper_keeper_http_basic'
        ) do |identity|
          identity.uid = SecureRandom.uuid
          identity.oauth_token = SecureRandom.uuid
        end

        Rails.logger.warn("api_identity = #{api_identity.inspect}")

        @identity = api_identity
      else
        @identity = provider_identity
      end

      respond_to do |format|
        if @identity.save
          format.json { render :show, status: :created, identity: @identity }
        else
          format.json { render json: @identity.errors, status: :unprocessable_entity }
        end
      end
    else
      render json: "error", status: :unprocessable_entity
    end
  end

  private

  def app_koala
    @app_koala ||= Koala::Facebook::API.new("#{APP_ID}|#{ENV['FACEBOOK_APP_SECRET']}")
  end

  def access_token_data(access_token)
    app_koala.debug_token(access_token)["data"]
  end

  def access_token_koala(access_token)
    Koala::Facebook::API.new(access_token)
  end

  def access_token_to_omniauth(access_token:, provider:)
    if provider == "facebook"
      facebook_access_token_to_omniauth(access_token)
    end
  end

  def facebook_access_token_to_omniauth(access_token)
    access_token_data = access_token_data(access_token)
    me = me(access_token)

    auth = OmniAuth::AuthHash.new
    auth.provider = 'facebook'

    auth.info = Hashie::Mash.new
    auth.info.name = me.fetch('name')

    auth.credentials = Hashie::Mash.new
    auth.credentials.token = access_token
    auth.credentials.expires_at = access_token_data.fetch('expires_at')

    auth.uid = access_token_data.fetch('user_id')

    auth
  end

  def identity_params
    params.require(:access_token)
    params.require(:provider)
    params
  end

  def me(access_token)
    access_token_koala(access_token).get_object("me")
  end

  def valid_access_token?(access_token:, provider:)
    if provider == "facebook"
      valid_facebook_access_token?(access_token)
    else
      false
    end
  end

  def valid_facebook_access_token?(access_token)
    data = access_token_data(access_token)

    if data
      data["is_valid"] && data["app_id"] == APP_ID
    else
      false
    end
  end
end
