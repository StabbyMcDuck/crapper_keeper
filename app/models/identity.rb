class Identity
  include Neo4j::ActiveNode

  IMMUTABLE_PROVIDERS = ['facebook', 'github'].freeze

  property :provider, type: String
  property :oauth_token, type: String
  property :oauth_expires_at, type: DateTime
  property :uid, type: String

  has_one :in, :user, type: :LOGS_IN_WITH

  # Validations

  validates :provider,
            presence: true
  validates :uid,
            presence: true
  validates :user,
            presence: true

  # Class Methods

  def self.ensure_user(auth:, identity:)
    unless identity.user.present?
      identity.user = User.create(name: auth.info.name)
      identity.save
    end
  end

  def self.find_with_omniauth(auth)
    update_oauth(find_by(provider: auth["provider"], uid: auth["uid"]), auth.credentials)
  end

  def self.find_or_create_with_omniauth(auth)
    find_with_omniauth(auth) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    attributes = {
        provider: auth["provider"],
        uid: auth["uid"]
    }

    credentials = auth.credentials

    if credentials
      attributes["oauth_token"] = credentials.oauth_token

      expires_at = credentials.expires_at

      unless expires_at.blank?
        attributes["oauth_expires_at"] = Time.at(expires_at)
      end
    end

    create(attributes)
  end

  def self.update_oauth(identity, credentials)
    if identity
      identity.update_oauth(credentials)
    end
  end

  # Instance Methods

  def update_oauth(credentials)
    if credentials
      self.oauth_token = credentials.token

      expires_at = credentials.expires_at
      self.oauth_expires_at = Time.at(expires_at) unless expires_at.blank?

      save!
    end

    self
  end
end
