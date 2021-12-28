class Notification < ApplicationRecord
  belongs_to :user
  enum category: [:login, :followed]
  validates :message, presence: true
end
