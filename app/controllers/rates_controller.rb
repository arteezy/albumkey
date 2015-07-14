class RatesController < ApplicationController
  before_action :authenticate_user!

  def create
    rate = Rate.new(user_id: current_user.id, album_id: params[:id], rate: params[:rate].to_f)
    if rate.valid?
      rate.upsert
      render nothing: true, status: 201
    else
      render nothing: true, status: 400
    end
  end
end
