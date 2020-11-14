class Reservation < ApplicationRecord
  include Codenable

  belongs_to :vehicle

  validates :checkin, presence: true
  validates :paid, :left, inclusion: [true, false]
  validate :can_reservate?, on: :create

  private

  def can_reservate?
    errors.add(:vehicle_id, 'has already reserved') if vehicle.reservations.exists?(left: false)
  end
end
