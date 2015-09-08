require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test 'should create comment' do
    @post = posts(:one)
    assert_equal 0, @post.descendants_depth
    assert_difference('Post.count') do
      Comment.create!(
        parent: posts(:one),
        body: 'I like this post.',
        user: users(:one))
    end
    assert_equal 1, Post.find(@post.id).descendants_depth
  end
end