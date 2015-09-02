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

  test 'user cannot upvote the same post a second time' do
    Upvote.create!(user: users(:one), post: posts(:one))
    assert_raises(DuplicateUpvote) do
      Upvote.create!(user: users(:one), post: posts(:one))
    end
  end

  test 'upvote destroys a vote' do
    Upvote.create!(user: users(:one), post: posts(:one))
    assert_difference('Vote.count', -1) do
      Upvote.destroy!(user: users(:one), post: posts(:one))
    end
  end


  test 'user decrements a posts vote count' do
    assert_difference('posts(:one).votes') do
      Upvote.create!(user: users(:one), post: posts(:one))
    end
    assert_difference('posts(:one).votes',  -1) do
      Upvote.destroy!(user: users(:one), post: posts(:one))
    end
  end

  test 'attempting to remove a nonexistent upvote throws exception' do
    assert_raises(UpvoteNotFound) do
      Upvote.destroy!(user: users(:one), post: posts(:one))
    end
  end
end
