class StaticPagesController < ApplicationController
  def home
    friend_ids = current_user.friends.map do |friend|
      friend.id
    end

    @posts = Post.where(friend_ids.include?(:user_id)).order(created_at: :desc)
  end
end
