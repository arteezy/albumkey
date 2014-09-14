class ArticlesController < ApplicationController
  def show
    @article = Article.where(artist: params[:id])
  end

  def index
    @articles = Article.all.distinct(:artist)
  end

  def create
    Article.new
  end
end
