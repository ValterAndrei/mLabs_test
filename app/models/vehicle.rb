class Vehicle < ApplicationRecord
  validates :plate, format: { with: /[a-zA-Z]{3}-\d{4}/, message: 'invalid format' }, uniqueness: true
end
