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

  def time
    self.checkout ||= Time.zone.now

    duration = ActiveSupport::Duration
               .build(checkout - checkin)
               .parts
               .slice(:days, :hours, :minutes, :seconds)

    duration.map do |k, v|
      "#{v.round(1)} #{k.to_s.delete_suffix('s').pluralize(v)}"
    end.to_sentence(words_connector: ', ', last_word_connector: ' e ')
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
