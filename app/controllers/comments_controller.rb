class CommentsController < ApplicationController
  def show
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @comment = Comment.all(params[:id])
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end
end
