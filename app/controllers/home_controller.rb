class HomeController < ApplicationController
  def cities
    cities = CS.cities(params[:state], :BR)
    render json: cities
  end
end
