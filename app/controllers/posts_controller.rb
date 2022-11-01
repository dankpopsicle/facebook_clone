class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @post = Post.all(params[:id])
    @post.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
