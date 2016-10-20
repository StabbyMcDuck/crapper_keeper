class Container 
  include Neo4j::ActiveNode
  property :name, type: String
  property :description, type: String

  has_one :in, :parent, type: :CONTAINS
  has_many :out, :items, type: :CONTAINS
  has_many :out, :containers, type: :CONTAINS
  has_one :in, :user, type: :OWNS


end
