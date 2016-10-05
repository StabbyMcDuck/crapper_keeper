class Container < ApplicationRecord
  acts_as_nested_set

  # associations
  has_many :items
end
