class Container < ApplicationRecord
  acts_as_nested_set dependent: :destroy

  # associations
  has_many :items, dependent: :destroy
end
