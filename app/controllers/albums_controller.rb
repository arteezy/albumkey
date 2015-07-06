class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]

  # GET /albums
  # GET /albums.json
  def index
    params[:order] ||= 'date'
    params[:dir] ||= 'desc'
    params[:rating] ||= '0.0-10.0'

    rating = params[:rating].split('-')
    min_rating = rating[0]
    max_rating = rating[1]

    selectors = []
    selectors << { artist: params[:artist] } if params[:artist]
    selectors << { year: params[:year] } if params[:year]
    selectors << { label: params[:label] } if params[:label]
    selectors << { reissue: false } if params[:reissue]
    selectors << { bnm: false } if params[:bnm]

    @albums = Album.all_of(*selectors)
                  .gte(rating: min_rating).lte(rating: max_rating)
                  .order_by(params[:order] => params[:dir])
                  .includes(:rates)
                  .page(params[:page])
  end

  def artists
    @artists = Rails.cache.fetch 'artists', expires_in: 1.hour do
      Album.distinct('artist').sort
    end
  end

  def labels
    @labels = Rails.cache.fetch 'labels', expires_in: 1.hour do
      Album.distinct('label').sort
    end
  end

  def search
    @albums = Album.search_by_artist(params[:search]).page(params[:page])
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:title, :artist, :label, :year, :date, :artwork, :source, :rating, :reissue, :bnm)
    end
end
