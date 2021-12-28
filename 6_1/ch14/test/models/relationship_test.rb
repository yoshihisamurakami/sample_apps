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

  test "Relationship.recent_followers_count" do
    Relationship.destroy_all
    @relationship.save

    Relationship.create!(
      follower_id: users(:lana).id,
      followed_id: users(:archer).id
    )
    Relationship.create!(
      follower_id: users(:archer).id,
      followed_id: users(:lana).id
    )
    assert_equal 1, Relationship.recent_followers_count(users(:archer).id) # :archer は :michael他1名からフォローされている
    assert_equal 0, Relationship.recent_followers_count(users(:lana).id)   # :lana は 1名からしかフォローされていない
  end
end
