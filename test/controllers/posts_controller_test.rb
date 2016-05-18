require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    sign_in users(:one)
    get :new
    assert_response :success
  end

  test "should create post" do
    sign_in users(:one)
    assert_difference('Post.count') do
      post = {
        body: @post.body,
        title: @post.title,
        subtreddit_id: subtreddits(:one).id
      }

      process :create, method: :post, params: { post: post }
    end

    assert_redirected_to post_path(assigns(:post))

    assert_no_difference('Post.count') do
      post = {
        body: nil,
        title: @post.title,
        subtreddit_id: subtreddits(:one).id
      }

      process :create, method: :post, params: { post: post }
    end
  end

  test "should show post" do
    process :show, method: :get, params: { id: @post }
    assert_response :success
  end

  test "should get edit" do
    skip
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    sign_in users(:one)
    post = { body: @post.body, title: @post.title }
    process :update, method: :patch, params: { id: @post, post: post }

    assert Post.find(@post.id).edited, 'Post should be edited after updating.'
    assert_response :success
  end

  test "user should login to update post" do
    post = { body: @post.body, title: @post.title }
    process :update, method: :post, params: { id: @post, post: post }
    assert_redirected_to new_user_session_path
  end

  test "should update post only if it belongs to them" do
    sign_in users(:one)
    post = posts(:two)
    post_params = { body: post.body, title: post.title }

    process :update, method: :patch, params: { id: post.id, post: post_params }
    assert_response :unauthorized
  end

  test "should destroy post" do
    skip
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end
end
