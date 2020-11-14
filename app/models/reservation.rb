class Reservation < ApplicationRecord
  include Codenable

  belongs_to :vehicle

  validates :checkin, presence: true
  validates :paid, :left, inclusion: [true, false]

  validate :can_reservate?, on: :create
  validate :can_left?,      on: :update

  def as_json(_options = {})
    super(only: %i[code])
  end

  def time
    self.checkout ||= Time.zone.now

    ActiveSupport::Duration.build(checkout - checkin).inspect
  end

  private

  def can_reservate?
    return unless vehicle.reservations.exists?(left: false)

    errors.add(:vehicle, 'vehicle still in the parking lot')
  end

  def can_left?
    errors.add(:left, 'payment not yet made') unless paid
  end
end
