require "test_helper"

class FollowedNotificationBuilderTest < ActiveSupport::TestCase
  def setup
    Notification.where(category: :followed).destroy_all
    Relationship.destroy_all

    @user_michael = users(:michael)
    @user_archer = users(:archer)
    @user_lana = users(:lana)
    @user_malory = users(:malory)
  end

  test "初回フォローされたとき" do
    builder = FollowedNotificationBuilder.new(user: @user_michael, follower: @user_archer)
    builder.build!
    notification = Notification.last
    assert_equal @user_michael.id, notification.user_id
    assert_equal "followed", notification.category
    assert_equal "Sterling Archerさんにフォローされました", notification.message
  end

  test "5分以内に2人目からフォローをされたとき" do
    # 1人目のフォロー
    @user_archer.follow(@user_michael)
    FollowedNotificationBuilder.new(user: @user_michael, follower: @user_archer).build!

    # 2人目のフォロー
    @user_lana.follow(@user_michael)
    FollowedNotificationBuilder.new(user: @user_michael, follower: @user_lana).build!

    notification = Notification.last
    assert_equal @user_michael.id, notification.user_id
    assert_equal "followed", notification.category
    assert_equal "Sterling Archerさん他1名にフォローされました", notification.message
  end

  test "5分以内に3人目からフォローをされたとき" do
    # 1人目のフォロー
    @user_archer.follow(@user_michael)
    FollowedNotificationBuilder.new(user: @user_michael, follower: @user_archer).build!

    # 2人目のフォロー
    @user_lana.follow(@user_michael)
    FollowedNotificationBuilder.new(user: @user_michael, follower: @user_lana).build!

    # 3人目のフォロー
    @user_malory.follow(@user_michael)
    FollowedNotificationBuilder.new(user: @user_michael, follower: @user_malory).build!

    notification = Notification.last
    assert_equal @user_michael.id, notification.user_id
    assert_equal "followed", notification.category
    assert_equal "Sterling Archerさん他2名にフォローされました", notification.message
  end

  test "5分以上間をあけて2人目からフォローされたとき" do
    notification_count = Notification.count

    # 1人目のフォロー
    @user_archer.follow(@user_michael)
    FollowedNotificationBuilder.new(user: @user_michael, follower: @user_archer).build!

    # 最新の通知の更新時間を6分前にする
    notification = Notification.last
    notification.update!(updated_at: Time.current - 6.minutes)

    # 2人目のフォロー
    @user_lana.follow(@user_michael)
    FollowedNotificationBuilder.new(user: @user_michael, follower: @user_lana).build!

    notification = Notification.last
    assert_equal @user_michael.id, notification.user_id
    assert_equal "followed", notification.category
    assert_equal "Lana Kaneさんにフォローされました", notification.message

    # notificationsレコードが2件増えていること
    assert_equal 2, Notification.count - notification_count
  end

end