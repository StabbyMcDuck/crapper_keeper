class Item < ApplicationRecord
  # constants
  NOTIFICATION_FREQUENCIES = %w(immediately daily weekly monthly)
  NOTIFICATION_FREQUENCY_SET = Set.new NOTIFICATION_FREQUENCIES
  NOTIFICATION_STYLES = %w(none in-app)

  # validations
  validate :notification_frequencies_subset

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
  validates :notification_style,
            inclusion: {
                in: NOTIFICATION_STYLES
            }

  # associations
  belongs_to :container

  # methods

  private

  def notification_frequencies_set
    Set.new(notification_frequencies)
  end

  def notification_frequencies_subset
    unless notification_frequencies_set.subset?(NOTIFICATION_FREQUENCY_SET)
      errors.add(:notification_frequencies, 'must be a subset of the allowed frequencies')
    end
  end
end
