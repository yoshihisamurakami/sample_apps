class Notification < ApplicationRecord
  belongs_to :user
  enum category: [:login, :followed]
  validates :message, presence: true

  def self.build!(user:, category:)
    if category == :login
      builder = LoginNotificationBuilder.new(user: user)
      builder.build!
    end
  end
end
