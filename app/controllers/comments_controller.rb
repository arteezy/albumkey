class CommentsController < ApplicationController
  before_action :set_parent_album
  before_action :set_comment, except: :create

  def create
    @comment = @album.comments.new(comment_params)
    @comment.user = current_user
    @comment.user_name = current_user.username
    @comment.user_avatar = current_user.gravatar_url

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @album, notice: 'Comment was successfully added' }
        format.json { render json: @comment, status: :created }
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
        format.json { render json: @comment, status: :ok }
      else
        format.html { redirect_to @album, alert: 'Unable to update comment' }
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
