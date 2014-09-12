class TopController < ApplicationController
  def index
    @top = Article.where(year: params[:year], bnr: false).order_by(:score.desc).limit(20)
  end
end
