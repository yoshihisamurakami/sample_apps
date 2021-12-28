class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  # フォローされたときの通知メッセージ「○○さん他?人にフォローされました」表示用の人数
  # NOTE: 
  #   コーディングテスト用のため、フォロアーが大人数になるケースは想定していません。
  #   フォロアーが1000人を超えるなどの場合は、重くなる可能性があります。
  def self.recent_followers_count(followed_id)
    relations = Relationship.where(followed_id: followed_id).order(created_at: :desc)
    created_at = relations.first.created_at
    count = 0
    relations.each do |relation|
      next if relation.created_at == created_at
      break if relation.created_at < created_at - 5.minutes
      count += 1
      created_at = relation.created_at
    end
    count
  end
end
