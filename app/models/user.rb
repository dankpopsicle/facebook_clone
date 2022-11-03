class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Gravtastic
  gravtastic

  after_create :send_confirmation_email

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :friend_requests
  has_many :pending_friends, through: :friend_requests, foreign_key: :friend_id
  has_many :notifications
  has_many :posts
  has_many :comments
  has_many :likes

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

end
