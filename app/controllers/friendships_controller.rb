class FriendshipsController < ApplicationController
  def index
    @friends = Friendship.all.where(user_id: params[:id])
  end

  def show
    @friend = User.find(params[:id])
    @friends = Friendship.all.where(user_id: params[:id])
  end

  def create
    @friend = User.find(params[:friend_id])
    @friendship = current_user.friendships.new(friend_id: @friend.id)
    if @friendship.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    redirect_back(fallback_location: root_path)
  end
end
