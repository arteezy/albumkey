class RateController < ApplicationController
  def create
    rate = Rate.where(user_id: current_user.id, album_id: params[:id])
    if rate.exists?
      rate.update(rate: params[:rate].to_f)
    else
      rate.create(rate: params[:rate].to_f)
    end

    redirect_to dash_path(artist: Album.find(params[:id])["artist"])
  end
end
