require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  setup do
    @post = posts(:one)
    @user = users(:one)
  end

  test 'should create comment' do
    assert_equal 0, @post.descendants_depth

    assert_difference('Post.count') do
      Comment.create!(
        parent: @post,
          body: 'I like this post.',
          user: @user
      )
    end

    @post.reload
    assert_equal 1, @post.descendants_depth

    comment = Post.find_by body: 'I like this post.'

    assert_not_nil      comment
    assert_equal @user, comment.user
    assert_equal @post, comment.parent
  end

  test 'should raise ArgumentError if create is not passed attributes' do
    assert_raises(ArgumentError) { Comment.create! }
  end

  test 'should save and return ActiveRecord model if valid' do
    comment = Comment.new(
      parent: @post,
        body: 'I like this post.',
        user: @user
    )
    assert_not_nil comment.save!
  end
end