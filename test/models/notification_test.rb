require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
            password: "password", password_confirmation: "password")
    @user_two = User.new(first_name: "Exampletwo", last_name: "User", email: "usertwo@example.com",
                password: "password", password_confirmation: "password")
    @user.save
    @user_two.save
  end

  test "should generate notification when friend request is sent" do
    @user.friend_requests.create!(friend_id: @user_two.id)
    assert_equal 1, @user_two.notifications.count
  end

  test "should generate notification for each person when a friendship is created" do
    @user.friend_requests.create!(friend_id: @user_two.id)
    @user_two.friendships.create!(friend_id: @user.id)
    assert_equal 1, @user_two.notifications.count
    assert_equal 1, @user.notifications.count
  end
end
