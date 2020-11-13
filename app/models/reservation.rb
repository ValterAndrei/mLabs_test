class Reservation < ApplicationRecord
  include Codenable

  validates :checkin, :checkout, presence: true
  validates :paid, :left, inclusion: [true, false]
end
