class ArticlesController < ApplicationController
    def show
        @article = Article.where(artist: params[:id])
    end

    def index
    	Article.all
    end
end
