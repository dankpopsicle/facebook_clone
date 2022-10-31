class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :friend_requests
  has_many :pending_friends, through: :friend_requests, foreign_key: :friend_id
  has_many :notifications
end
