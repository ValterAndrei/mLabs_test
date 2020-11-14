class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show]
  before_action :set_reservation, only: %i[pay out]

  def show
    if @vehicle
      json_response(@vehicle)
    else
      json_response({ message: 'Plate not found' })
    end
  end

  def create
    @vehicle = Vehicle.find_or_create_by!(plate: vehicle_params[:plate].upcase)
                      .reservations.build(checkin: Time.zone.now)

    if @vehicle.save
      json_response(@vehicle, :created)
    else
      json_response(@vehicle.errors.full_messages, :unprocessable_entity)
    end
  end

  def pay
    return json_response({ message: 'Reservation not fount' }) unless @reservation

    @reservation.paid = true

    if @reservation.save
      json_response(@reservation)
    else
      json_response(@reservation.errors.full_messages, :unprocessable_entity)
    end
  end

  def out
    return json_response({ message: 'Reservation not fount' }) unless @reservation

    @reservation.checkout = Time.zone.now
    @reservation.left = true

    if @reservation.save
      json_response(@reservation)
    else
      json_response(@reservation.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find_by(plate: params[:plate].upcase)
  end

  def set_reservation
    @reservation = Reservation.find_by(code: params[:code])
  end

  def vehicle_params
    params.require(:vehicle).permit(:plate)
  end
end
