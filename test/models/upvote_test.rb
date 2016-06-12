require 'test_helper'

class UpvoteTest < ActiveSupport::TestCase

  setup do
    @user = users(:one)
    @post = posts(:one)
  end

  test 'upvote creates a vote' do
    assert_difference('Vote.count') do
      Upvote.create!(user: @user, post: @post)
    end
  end

  test 'upvote increments a posts vote count' do
    assert_difference('@post.votes.count') do
      Upvote.create!(user: @user, post: @post)
    end
  end

  test 'user cannot upvote the same post a second time' do
    Upvote.create!(user: @user, post: @post)

    assert_raises(Upvote::DuplicateUpvote) do
      Upvote.create!(user: @user, post: @post)
    end
  end

  test 'upvote destroys a vote' do
    Upvote.create!(user: @user, post: @post)

    assert_difference('Vote.count', -1) do
      Upvote.destroy_all!(user: @user, post: @post)
    end
  end

  test 'user decrements a posts vote count' do
    assert_difference('@post.votes.count') do
      Upvote.create!(user: @user, post: @post)
    end

    assert_difference('@post.votes.count', -1) do
      Upvote.destroy_all!(user: @user, post: @post)
    end
  end

  test 'attempting to remove a nonexistent upvote throws exception' do
    assert_raises(Upvote::UpvoteNotFound) do
      Upvote.destroy_all!(user: @user, post: @post)
    end
  end
end
