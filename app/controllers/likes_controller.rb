class LikesController < ApplicationController

  def create
    @like = current_user.likes.build(like_params)
    if @like.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def like_params
    params.require(:like).permit(:post_id)
  end

end
