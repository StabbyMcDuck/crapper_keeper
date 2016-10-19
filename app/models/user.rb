class User 
  include Neo4j::ActiveNode
  property :provider, type: String
  property :uid, type: String
  property :name, type: String
  property :oauth_token, type: String
  property :oauth_expires_at, type: DateTime

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at) unless auth.credentials.expires_at.blank?
      user.save!
    end
  end

end
