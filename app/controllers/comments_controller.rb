class CommentsController < ApplicationController
  before_action :set_parent_album
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = @album.comments.all
  end

  def show
  end

  def new
    @comment = @album.comments.build
  end

  def edit
  end

  def create
    @comment = @album.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.user_email = current_user.email
    @comment.user_avatar = current_user.gravatar_url

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @album, notice: 'Comment was successfully added' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { redirect_to @album, alert: 'Unable to add comment' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @album, notice: 'Comment was successfully updated' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @album, alert: 'Comment was deleted' }
      format.json { head :no_content }
    end
  end

  private

  def set_parent_album
    @album = Album.find(params[:album_id])
  end

  def set_comment
    @comment = @album.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
