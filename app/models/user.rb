class User 
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  property :name, type: String
  property :updated_at, type: DateTime

  has_many :out, :containers, type: :OWNS
  has_many :out, :identities, type: :LOGS_IN_WITH

  def self.create_with_omniauth(info)
    create(name: info["name"])
  end
end
