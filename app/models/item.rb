class Item < ApplicationRecord
  # validations
  validates :name,
            presence: true
  validates :container,
            presence: true
  validates :count,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  # associations
  belongs_to :container
end
