class VehiclesController < ApplicationController
  before_action :set_vehicle,       only: %i[show destroy]
  before_action :set_reservation,   only: %i[pay out]
  before_action :check_vehicle,     only: %i[show]
  before_action :check_reservation, only: %i[pay out]

  def index
    @vehicles = Vehicle.includes(:reservations).order(:created_at)

    json_response(@vehicles)
  end

  def show
    json_response(@vehicle)
  end

  def create
    @vehicle = Vehicle.find_or_create_by!(plate: vehicle_params[:plate])
                      .reservations.build(checkin: Time.zone.now)

    if @vehicle.save
      json_response(@vehicle, :created)
    else
      json_response(@vehicle.errors.full_messages, :unprocessable_entity)
    end
  end

  def destroy
    @vehicle.destroy

    head :no_content
  end

  def pay
    @reservation.paid = true

    if @reservation.save
      json_response(@reservation)
    else
      json_response(@reservation.errors.full_messages, :unprocessable_entity)
    end
  end

  def out
    @reservation.checkout = Time.zone.now
    @reservation.left     = true

    if @reservation.save
      json_response(@reservation)
    else
      json_response(@reservation.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find_by(plate: params[:plate])
  end

  def set_reservation
    @reservation = Reservation.find_by(code: params[:code])
  end

  def vehicle_params
    params.require(:vehicle).permit(:plate)
  end

  def check_vehicle
    return if @vehicle

    json_response({ message: 'Vehicle not found' }, :not_found)
  end

  def check_reservation
    return if @reservation

    json_response({ message: 'Reservation not fount' }, :not_found)
  end
end
