class Vehicle < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :plate,
            format: { with: /[a-zA-Z]{3}-\d{4}/, message: 'with invalid format' },
            uniqueness: true

  def as_json(_options = {})
    super(
      only: %i[plate],
      include: {
        reservations: {
          only: %i[code paid left],
          methods: %i[time]
        }
      }
    )
  end
end
