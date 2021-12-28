class LoginNotificationBuilder
  def initialize(user:)
    @user = user
  end

  def build!
    return if exists_notice?
    Notification.create!(user: @user, category: :login, message: '初回ログインありがとうございます。')
  end

  private

  def exists_notice?
    Notification.where(user: @user, category: :login).exists?
  end
end