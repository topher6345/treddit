require 'test_helper'

class UpvoteTest < ActiveSupport::TestCase

  test 'upvote creates a vote' do
    assert_difference('Vote.count') do
      Upvote.create!(user: users(:one), post: posts(:one))
    end
  end

  test 'upvote increments a posts vote count' do
    assert_difference('posts(:one).votes') do
      Upvote.create!(user: users(:one), post: posts(:one))
    end
  end

  test 'upvote can access a post' do
    upvote = Upvote.create!(user: users(:one), post: posts(:one))
    assert_equal upvote.post, posts(:one)
  end
end
