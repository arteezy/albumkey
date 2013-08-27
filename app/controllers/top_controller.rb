class TopController < ApplicationController
  def show
    @top = Article.where(year: params[:year], bnr: false).order_by(:score.desc).limit(20)
  end
end
