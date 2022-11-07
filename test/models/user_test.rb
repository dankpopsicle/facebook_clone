require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
            password: "password", password_confirmation: "password")
    @user_two = User.new(first_name: "Exampletwo", last_name: "User", email: "usertwo@example.com",
                password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.first_name = "   "
    @user.last_name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "first name should not be too long" do
    @user.first_name = "a" * 51
    assert_not @user.valid?
  end

  test "last name should not be too long" do
    @user.last_name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                        foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid? "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMpLe.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "associated posts should be destroyed" do
    @user.save
    @user.posts.create!(content: "Lorem ipsum")
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end

  test "associated comments should be destroyed" do
    @user.save
    @user_two.save
    @user_two.posts.create!(content: "Lorem ipsum")
    @user_two.posts.first.comments.create!(user_id: @user.id, content: "Lorem ipsum")
    assert_difference 'Comment.count', -1 do
      @user.destroy
    end
  end

  test "associated likes should be destroyed" do
    @user.save
    @user_two.save
    @user_two.posts.create!(content: "Lorem ipsum")
    @user_two.posts.first.likes.create!(user_id: @user.id)
    assert_difference 'Like.count', -1 do
      @user.destroy
    end
  end

  test "associated sent friend requests should be destroyed" do
    @user.save
    @user_two.save
    @user.friend_requests.create!(friend_id: @user_two.id)
    assert_difference 'FriendRequest.count', -1 do
      @user.destroy
    end
  end

  test "associated received friend requests should be destroyed" do
    @user.save
    @user_two.save
    @user_two.friend_requests.create!(friend_id: @user.id)
    assert_difference 'FriendRequest.count', -1 do
      @user.destroy
    end
  end

  test "associated friendships should be destroyed" do
    @user.save
    @user_two.save
    @user_two.friend_requests.create!(friend_id: @user.id)
    @user.friendships.create!(friend_id: @user_two.id)
    #this is -2 instead of -1 because a friendship is created 
    #for each individual in the friendship; two friendships must be deleted
    assert_difference 'Friendship.count', -2 do
      @user.destroy
    end
  end

  test "associated notifications should be destroyed" do
    @user.save
    @user_two.save
    @user_two.friend_requests.create!(friend_id: @user.id)
    @user.friendships.create!(friend_id: @user_two.id)
    assert_difference 'Notification.count', -2 do
      @user.destroy
    end
  end
end
