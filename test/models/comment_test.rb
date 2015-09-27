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
        user: @user)
    end
    assert_equal 1, Post.find(@post.id).descendants_depth
  end

  test 'should raise ArgumentError if create is not passed attributes' do
    assert_raises(ArgumentError) do
      Comment.create!
    end
  end

  test 'should not be valid if all attributes are empty' do
    comment = Comment.new
    assert !comment.valid?

    comment.parent = @post
    assert !comment.valid?

    comment.body = 'I like this post.'
    assert !comment.valid?

    comment.user = @user
    assert comment.valid?
  end

  test 'should save and return ActiveRecord model if valid' do
    comment = Comment.new(
      parent: @post,
      body: 'I like this post.',
      user: @user)

    assert_not_nil comment.save!
  end
end