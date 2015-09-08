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
end