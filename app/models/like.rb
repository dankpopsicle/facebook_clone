class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validate :user_hasnt_already_liked

  private

  def user_hasnt_already_liked
    if post.likes.where(user_id: user.id).length >= 1
      self.errors.add(:like, "can't like a post more than once")
    end
  end
end
