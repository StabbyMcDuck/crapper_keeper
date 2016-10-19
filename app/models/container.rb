class Container 
  include Neo4j::ActiveNode
  property :name, type: String
  property :description, type: String

  has_one :in_or_out_or_both, :parent, type: :FILL_IN_RELATIONSHIP_TYPE_HERE
  has_one :in_or_out_or_both, :user, type: :FILL_IN_RELATIONSHIP_TYPE_HERE


end
