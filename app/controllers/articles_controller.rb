class ArticlesController < ApplicationController
    def score
        @article = Article.where(:score.gt => params[:score]).limit(10)
    end

    def show
        @article = Article.where(artist: params[:id])
    end

    def index
    	Article.all
    end
end
