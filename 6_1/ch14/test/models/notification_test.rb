require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  def setup
    @notification = Notification.new(user_id: users(:michael).id, category: :login, message: '初回ログインありがとうございます。')
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

  test "Notification.build! 初回ログイン時、通知が作成されること" do
    count = Notification.count
    Notification.build!(user: users(:michael), category: :login)
    assert_equal count + 1, Notification.count
  end

  test "Notification.build! フォローされたとき、通知が作成されること" do
    count = Notification.count
    Notification.build!(user: users(:michael), category: :followed, follower: users(:archer))
    assert_equal count + 1, Notification.count
  end
end
