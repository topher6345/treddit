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
      post :create, post: { body: @post.body, title: @post.title, subtreddit_id: subtreddits(:one).id }
    end

    assert_redirected_to post_path(assigns(:post))

    assert_no_difference('Post.count') do
      post :create, post: { body: nil, title: @post.title, subtreddit_id: subtreddits(:one).id  }
    end

  end

  test "should create comment on parent post" do
    sign_in users(:one)
    parent_post = @post

    assert_difference('Post.count') do
      post :create_comment, parent_post: parent_post.id, body: 'A comment', subtreddit_id: subtreddits(:one).id
    end

    assert_redirected_to post_path(parent_post)

    assert_no_difference('Post.count') do
      post :create_comment, parent_post: parent_post.id, body: nil, subtreddit_id: subtreddits(:one).id
    end
  end

  test 'user must login to upvote post' do
    put :upvote, id: @post
    assert_redirected_to new_user_session_path
  end

  test 'signed in user can upvote post' do
    sign_in users(:one)
    put :upvote, id: @post
    assert_response :success
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    skip
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    sign_in users(:one)
    patch :update, id: @post, post: { body: @post.body, title: @post.title }
    assert Post.find(@post.id).edited, 'Post should be edited after updating.'
    assert_response :success
  end

  test "user should login to update post" do
    patch :update, id: @post, post: { body: @post.body, title: @post.title }
    assert_redirected_to new_user_session_path
  end

  test "should update post only if it belongs to them" do
    sign_in users(:one)
    @post = posts(:two)
    patch :update, id: @post, post: { body: @post.body, title: @post.title }
    assert_response :unauthorized
  end

  test "should destroy post" do
    skip
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end


  test 'should remove upvote that exists' do
    sign_in users(:one)

    # Add upvote
    put :upvote, id: @post
    assert_response :success, 'Could not create upvote to test destroy upvote'

    delete :destroy_upvote, id: @post
    assert_response :success
  end
end
