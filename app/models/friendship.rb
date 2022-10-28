class Friendship < ApplicationRecord
  after_create :create_inverse_relationship
  after_create :destroy_friend_request
  after_destroy :destroy_inverse_relationship

  belongs_to :user
  belongs_to :friend, class_name: "User"

  validate :friendship_doesnt_exist
  validate :friend_not_user
  validate :friend_request_exists

  private

  def create_inverse_relationship
    friend.friendships.create(friend_id: user.id)
  end

  def destroy_inverse_relationship
    friendship = friend.friendships.find_by(friend_id: user.id)
    friendship.destroy if friendship
  end

  def destroy_friend_request
    request_one = FriendRequest.where(user_id: self.user_id, friend_id: self.friend_id).first
    request_two = FriendRequest.where(user_id: self.friend_id, friend_id: self.user_id).first
    request_one.destroy if request_one
    request_two.destroy if request_two
  end

  def friendship_doesnt_exist
    if user.friends.where(id: friend.id).length >= 1
      self.errors.add(:friend, "can't add a friend more than once")
    end
  end

  def friend_not_user
    if self.friend_id == self.user_id
      self.errors.add(:friend, "can't add yourself as a friend")
    end
  end

  def friend_request_exists
    if FriendRequest.where(user_id: self.user_id, friend_id: self.friend_id).length < 1 &&
      FriendRequest.where(user_id: self.friend_id, friend_id: self.user_id).length < 1
      self.errors.add(:friend, "can't add friends without a request")
    end
  end
end
