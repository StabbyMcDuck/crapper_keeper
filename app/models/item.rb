class Item
  include Neo4j::ActiveNode


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

  property :created_at, type: DateTime
  property :name, type: String
  property :description, type: String
  property :count, type: Integer
  property :last_used_at, type: DateTime
  property :notification_style, type: String
  property :notification_frequencies, type: String
  property :updated_at, type: DateTime

  has_one :in, :container, type: :CONTAINS

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
