class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.includes(:user).all
    authorize List
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    authorize @list
  end

  # GET /lists/new
  def new
    @list = List.new
    authorize @list
  end

  # GET /lists/1/edit
  def edit
    authorize @list
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)
    authorize @list
    @list.user = current_user

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    authorize @list
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    authorize @list
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed' }
      format.json { head :no_content }
    end
  end

  def move_album
    list = List.find(params[:list_id])
    authorize list
    album = Album.find(params[:album_id])
    list.move_album(album, params[:direction].to_sym)
    list.save!
    redirect_to list, turbolinks: true
  end

  def delete_album
    list = List.find(params[:list_id])
    authorize list
    album = Album.find(params[:album_id])
    list.delete_album(album)
    list.save!
    redirect_to list, turbolinks: true
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:title, :category)
  end
end
