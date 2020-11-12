class HomeController < ApplicationController
  def index
    validator = PlateValidator.new('bqf-9355').run

    render json: validator, status: :ok
  end
end
