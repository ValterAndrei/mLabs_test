class HomeController < ApplicationController
  def index
    render json: 'Hello World', status: :ok
  end
end
