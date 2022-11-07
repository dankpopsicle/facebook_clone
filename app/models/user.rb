class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Gravtastic
  gravtastic

  #after_create :send_confirmation_email
  before_destroy :destroy_received_friend_requests 
  after_destroy :destroy_notifications_including_user

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, foreign_key: :friend_id
  has_many :notifications, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.name
      user.last_name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def send_confirmation_email
    UserMailer.with(user: self).welcome_email.deliver_now
  end

  def destroy_received_friend_requests
    FriendRequest.where(friend_id: self.id).each do |request|
      request.destroy
    end
  end

  def destroy_notifications_including_user
    Notification.where(interacting_user_id: self.id).each do |notification|
      notification.destroy
    end
  end

end
