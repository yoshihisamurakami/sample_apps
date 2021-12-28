require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  # Relationship.recent_followers_count のテスト
  test "Relationship.recent_followers_count: 1人からフォローされているとき" do
    Relationship.destroy_all
    users(:archer).follow(users(:michael))
    assert_equal 0, Relationship.recent_followers_count(users(:michael).id)
  end

  test "Relationship.recent_followers_count: 2人からフォローされているとき" do
    Relationship.destroy_all
    users(:archer).follow(users(:michael))
    users(:lana).follow(users(:michael))
    assert_equal 1, Relationship.recent_followers_count(users(:michael).id)
  end

  test "Relationship.recent_followers_count: 3人からフォローされているとき" do
    Relationship.destroy_all
    users(:archer).follow(users(:michael))
    users(:lana).follow(users(:michael))
    users(:malory).follow(users(:michael))
    assert_equal 2, Relationship.recent_followers_count(users(:michael).id)
  end

  test "Relationship.recent_followers_count: 2人からフォローされたあと、5分以上経ったあとに1人からフォローされたとき" do
    Relationship.destroy_all
    users(:archer).follow(users(:michael))
    users(:lana).follow(users(:michael))
    Relationship.update_all(created_at: Time.current - 5.minutes)

    users(:malory).follow(users(:michael))
    assert_equal 0, Relationship.recent_followers_count(users(:michael).id)
  end
end
