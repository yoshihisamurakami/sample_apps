# ユーザーがフォローされたときの通知を作成
class FollowedNotificationBuilder
  def initialize(user:, follower:)
    @user = user
    @follower = follower
  end

  def build!
    if notification_within_5_minutes.nil?
      build_on_first_time!
    else
      update_message!(notification_within_5_minutes)
    end
  end

  private

  def notification_within_5_minutes
    @notification_within_5_minutes ||= Notification.where(
        user: @user,
        category: :followed
      ).where(
        'updated_at > ?', Time.current - 5.minutes
      ).order(updated_at: :desc)
      .first
  end

  def build_on_first_time!
    Notification.create!(
      user: @user,
      category: :followed,
      message: first_followed_message
    )
  end

  def first_followed_message
    "#{@follower.name}さんにフォローされました"
  end

  def update_message!(notification)
    notification.update!(message: updated_message(notification))
  end

  def updated_message(notification)
    if recent_followers_count.zero?
      first_followed_message
    else
      "#{first_follower(notification.message)}さん他#{recent_followers_count}名にフォローされました"
    end
  end

  def first_follower(message)
    if message.match(/\A(.*?)さん他(\d+)名にフォローされました\z/)
      $1
    elsif message.match(/\A(.*?)さんにフォローされました\z/)
      $1
    end
  end 

  def recent_followers_count
    @recent_followers_count ||= Relationship.recent_followers_count(@user.id)
  end
end