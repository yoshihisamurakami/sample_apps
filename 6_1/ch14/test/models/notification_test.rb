require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  def setup
    user = User.create!(name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")
    @notification = Notification.new(user_id: user.id, category: 0, message: '初回ログインありがとうございます。')
  end

  test "should be valid" do
    assert @notification.valid?
  end

  test "user_id should be present" do
    @notification.user_id = nil
    assert_not @notification.valid?
  end

  test "message should be present" do
    @notification.message = nil
    assert_not @notification.valid?
  end
end
