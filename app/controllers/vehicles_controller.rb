class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show]

  def show
    json_response(@vehicle)
  end

  def create
    @vehicle = Vehicle.find_or_create_by!(plate: vehicle_params[:plate])
                      .reservations.build(checkin: Time.now)

    if @vehicle.save
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
