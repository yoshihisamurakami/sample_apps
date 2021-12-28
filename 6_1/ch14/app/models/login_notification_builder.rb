# 初回ログインされたときの通知を作成する
class LoginNotificationBuilder
  def initialize(user:)
    @user = user
  end

  def build!
    return if exist_notification?
    Notification.create!(user: @user, category: :login, message: '初回ログインありがとうございます。')
  end

  private

  def exist_notification?
    Notification.where(user: @user, category: :login).exists?
  end
end