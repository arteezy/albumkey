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
                   .rating_range(min_rating, max_rating)
                   .albums_order(params[:order], params[:dir])
                   .search(params[:search])
                   .page(params[:page])
  end

  # GET /api/artists.json
  def artists
    @artists = Rails.cache.fetch 'artists', expires_in: 1.hour do
      Album.distinct('artist').sort
    end
  end

  # GET /api/labels.json
  def labels
    @labels = Rails.cache.fetch 'labels', expires_in: 1.hour do
      Album.distinct('label').sort
    end
  end

  def search
    @albums = Album.search(params[:search]).page(params[:page])
  end

  # GET /stats
  # GET /stats.json
  def stats
    pipeline = []
    pipeline << {
      '$match' => {
        'date' => {
          '$gte' => Date.new(params[:year].to_i, 1, 1),
          '$lte' => Date.new(params[:year].to_i, 12, 31)
        }
      }
    } if params[:year]
    pipeline << {
      '$group' => {
        '_id' => '$date',
        'avg_rating' => { '$avg' => '$rating' }
      }
    }
    pipeline << { '$sort' => { '_id' => 1 } }

    @stats = Album.collection.aggregate(pipeline)

    @total = {
      album: Album.count,
      bnm: Album.where(bnm: true).count,
      reissue: Album.where(reissue: true).count
    }

    respond_to do |format|
      format.html { render :stats }
      format.json { render json: @stats }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @comments = @album.comments.all
    return unless user_signed_in?
    @comment = @album.comments.build

    if @album.rates.where(user_id: current_user.id).exists?
      @rate = @album.rates.find_by(user_id: current_user.id).rate
    end
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
