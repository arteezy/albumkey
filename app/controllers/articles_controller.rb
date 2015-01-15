class ArticlesController < ApplicationController
  def show
    @articles = Article.where(artist: params[:id]).desc(:date).includes(:rates).page(params[:page])
  end

  def index
    @articles = Kaminari.paginate_array(Article.search(params[:search])).page(params[:page])
  end

  def create
    Article.new
  end
end
