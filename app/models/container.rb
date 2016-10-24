class Container 
  include Neo4j::ActiveNode
  property :created_at, type: DateTime
  property :name, type: String
  property :description, type: String
  property :updated_at, type: DateTime

  has_one :in, :parent, type: :CONTAINS, model_class: :Container
  has_many :out, :items, type: :CONTAINS
  has_many :out, :containers, type: :CONTAINS
  has_one :in, :user, type: :OWNS

  # validations
  validates :name,
            presence: true

  validates :user,
            presence: true
end
