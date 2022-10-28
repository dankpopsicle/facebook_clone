class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :friend_id, presence: true
  validate :friend_not_user, on: :create
  validate :request_doesnt_exist
  validate :friendship_doesnt_exist

  def friend_not_user
    if self.friend_id == self.user_id
      self.errors.add(:friend, "can't add yourself as a friend")
    end
  end

  def request_doesnt_exist
    if (FriendRequest.where(user_id: self.user_id, friend_id: friend.id).length >= 1) || 
      (FriendRequest.where(user_id: friend.id, friend_id: self.user_id).length >= 1)
       self.errors.add(:friend, "can't send a request when a request already exists")
    end
  end

  def friendship_doesnt_exist
    if Friendship.where(user_id: self.user_id, friend_id: friend.id).length >= 1
      self.errors.add(:friend, "can't send a request to someone you are friends with")
    end
  end
end
