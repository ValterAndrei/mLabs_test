class Vehicle < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :plate,
            plate: true,
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
