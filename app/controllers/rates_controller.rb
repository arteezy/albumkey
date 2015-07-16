class RatesController < ApplicationController
  before_action :authenticate_user!

  def create
    rate = Rate.find_or_initialize_by(user: current_user, album_id: params[:album_id])
    rate.rate = params[:rate]
    if rate.save
      render nothing: true, status: 201
    else
      render nothing: true, status: 400
    end
  end
end
