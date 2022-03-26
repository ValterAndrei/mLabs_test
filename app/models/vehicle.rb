class Vehicle < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :plate,
            format: { with: /[A-Z]{3}-[0-9][0-9A-Z][0-9]{2}/, message: 'with invalid format' },
            uniqueness: true

  def as_json(_options = {})
    super(
      only: %i[plate],
      include: {
        reservations: {
          only: %i[code paid left created_at checkout],
          methods: %i[time plate]
        }
      }
    )
  end
end
