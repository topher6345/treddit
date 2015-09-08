require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test 'should create child post' do
    assert_difference('Post.count') do
      comment = Comment.new(
        parent: posts(:one),
        body: 'I like this post.',
        user: users(:one))
      comment.create_post
    end
  end

  test 'should update parent cache' do
    @post = posts(:one)
    assert_equal 0, @post.descendants_depth
    comment = Comment.new(
        parent: posts(:one),
        body: 'I like this post.',
        user: users(:one))
    comment.update_parent_cache
    assert_equal 1, @post.descendants_depth
  end

  test 'should create comment' do
    @post = posts(:one)
    assert_equal 0, @post.descendants_depth
    assert_difference('Post.count') do
      Comment.create!(
        parent: posts(:one),
        body: 'I like this post.',
        user: users(:one))
    end
    assert_equal 1, @post.descendants_depth
  end
end