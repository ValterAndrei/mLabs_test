class Reservation < ApplicationRecord
  include Codenable

  belongs_to :vehicle

  validates :checkin, presence: true
  validates :paid, :left, inclusion: [true, false]

  validate :can_reservate?, on: :create
  validate :can_left?,      on: :update

  delegate :plate, to: :vehicle

  def as_json(_options = {})
    super only: %i[code]
  end

  def time # rubocop:disable Metrics/MethodLength
    self.checkout ||= Time.zone.now

    duration = ActiveSupport::Duration
               .build(checkout - checkin)
               .parts
               .slice(:days, :hours, :minutes)

    case duration
    in { days: Integer, hours: Integer, minutes: Integer }
      "#{duration[:days]} days, #{duration[:hours]} hours and #{duration[:minutes]} minutes"
    in { hours: Integer, minutes: Integer }
      "#{duration[:hours]} hours and #{duration[:minutes]} minutes"
    in { minutes: Integer }
      "#{duration[:minutes]} minutes"
    else
      nil
    end
  end

  private

  def can_reservate?
    return unless vehicle.reservations.exists?(left: false)

    errors.add(:vehicle, 'still in the parking lot')
  end

  def can_left?
    errors.add(:reservation, 'payment not yet made') unless paid
  end
end
