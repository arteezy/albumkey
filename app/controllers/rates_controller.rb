class RatesController < ApplicationController
  before_action :authenticate_user!

  def create
    rate = Rate.new(user: current_user, album_id: params[:album_id], rate: params[:rate])
    if rate.valid?
      rate.upsert
      render nothing: true, status: 201
    else
      render nothing: true, status: 400
    end
  end
end
