class Vehicle < ApplicationRecord
  validates :plate,
            format: { with: /[a-zA-Z]{3}-\d{4}/, message: 'with invalid format' },
            uniqueness: true

  before_create :generate_reservation

  def generate_reservation
    { code: 'Teste' }
  end
end
