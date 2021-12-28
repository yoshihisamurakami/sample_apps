class Notification < ApplicationRecord
  belongs_to :user
  enum category: [:login, :followed]
  validates :message, presence: true

  def self.build!(user:, category:, follower: nil)
    if category == :login
      builder = LoginNotificationBuilder.new(user: user)
      builder.build!
    elsif category == :followed
      builder = FollowedNotificationBuilder.new(user: user, follower: follower)
      builder.build!
    end
  end
end
