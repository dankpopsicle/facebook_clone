class FriendRequestsController < ApplicationController
  def index
    @received_requests = FriendRequest.where(friend: current_user)
    @sent_requests = FriendRequest.where(user: current_user)
  end

  def create
    @friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.build(friend_id: @friend.id)
    if @friend_request.save
      redirect_back(fallback_location: root_path)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy
    redirect_back(fallback_location: root_path)
  end
end
