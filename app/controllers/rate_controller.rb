class RateController < ApplicationController
  def create
    Rate.create(user_id: current_user.id, article_id: params[:id], rate: params[:rate])
    redirect_to article_path(Article.find(params[:id])["artist"])
  end
end
