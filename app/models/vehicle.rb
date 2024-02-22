class Vehicle < ApplicationRecord
  has_many :reservations, dependent: :destroy

  has_one_attached :photo, dependent: :destroy

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
      },
      methods: %i[photo_url]
    )
  end


  private

  def photo_url
    photo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(photo) : nil
  end

end
