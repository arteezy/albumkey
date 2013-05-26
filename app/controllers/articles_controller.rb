class ArticlesController < ApplicationController
    def view
        @article = Article.find_by(artist: params[:name])
    end
end
