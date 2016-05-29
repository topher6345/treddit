require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should create comment on parent post" do
    sign_in users(:one)
    parent_post = @post

    assert_difference('Post.count') do
      process :create, method: :post, params: {
        post_id: parent_post.id, body: 'A comment', subtreddit_id: subtreddits(:one).id
      }
    end

    @comment = assigns(:comment)
    dom_id = "/#H#{@comment.id}"

    assert_redirected_to post_path(@post.root.id)+dom_id

    assert_no_difference('Post.count') do
      process :create, method: :post, params: {
        post_id: parent_post.id, body: nil, subtreddit_id: subtreddits(:one).id
      }
    end
  end
end
