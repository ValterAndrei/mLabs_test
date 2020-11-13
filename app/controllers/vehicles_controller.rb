class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show]

  def show
    json_response(@vehicle)
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    if Vehicle.exists?(plate: @vehicle.plate)
      json_response(@vehicle.generate_reservation, :created)
    elsif @vehicle.save
      json_response(@vehicle, :created)
    else
      json_response(@vehicle.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find_by(plate: params[:plate])
  end

  def vehicle_params
    params.require(:vehicle).permit(:plate)
  end
end
