class StaticPagesController < ApplicationController
  def home
    friends = current_user.friends.map do |friend|
      friend
    end

    #@posts = Post.where(friend_ids.include?(:user_id)).order(created_at: :desc)
    @posts = Post.where(user: friends).or(Post.where(user: current_user))
  end
end
