class Item 
  include Neo4j::ActiveNode
  property :name, type: String
  property :description, type: String
  property :count, type: Integer
  property :last_used_at, type: DateTime
  property :notification_style, type: String
  property :notification_frequencies, type: String

  has_one :in_or_out_or_both, :container, type: :FILL_IN_RELATIONSHIP_TYPE_HERE


end
