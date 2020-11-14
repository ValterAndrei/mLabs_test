class Reservation < ApplicationRecord
  include Codenable

  belongs_to :vehicle

  validates :checkin, presence: true
  validates :paid, :left, inclusion: [true, false]
end
