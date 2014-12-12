class ArticlesController < ApplicationController
  def show
    @articles = Article.where(artist: params[:id])
  end

  def index
    @articles = Article.search(params[:search])
  end

  def create
    Article.new
  end
end
