class ArticlesController < ApplicationController
    def show
        @article = Article.where(artist: params[:id])
    end

    def index
        Article.all
    end

    def create
        Article.new
    end
end
