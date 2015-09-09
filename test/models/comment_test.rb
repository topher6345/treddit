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

  test 'should raise ArgumentError if create is not passed attributes' do
    assert_raises(ArgumentError) do
      Comment.create!
    end
  end

  test 'should not be valid if all attributes are empty' do
    comment = Comment.new
    assert_raises(ActiveModel::StrictValidationFailed) do
      comment.valid?
    end
    comment.parent = posts(:one)
    assert_raises(ActiveModel::StrictValidationFailed) do
      comment.valid?
    end
    comment.body = 'I like this post.'
    assert_raises(ActiveModel::StrictValidationFailed) do
      comment.valid?
    end
    comment.user = users(:one)
    assert comment.valid?
  end

  test 'should save and return ActiveRecord model if valid' do
    comment = Comment.new(
        parent: posts(:one),
        body: 'I like this post.',
        user: users(:one))

    assert_not_nil comment.save!
  end
end