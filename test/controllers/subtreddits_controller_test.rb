require 'test_helper'

class SubtredditsControllerTest < ActionController::TestCase
  setup do
    @subtreddit = subtreddits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subtreddits)
  end

  test "should get new" do
    skip
    get :new
    assert_response :success
  end

  test 'should not create subtreddit if not logged in' do
    assert_no_difference('Subtreddit.count') do
      post :create, subtreddit: { description: 'My favorite instrument.', name: 'Guitar' }
    end

    assert_redirected_to new_user_session_path
  end

  test "should create subtreddit if logged in" do
    sign_in users(:one)

    assert_difference('Subtreddit.count') do
      post :create, subtreddit: { description: 'My favorite instrument.', name: 'Guitar' }
    end

    assert_redirected_to subtreddit_path(assigns(:subtreddit))
  end

  test "should show subtreddit" do
    get :show, name: @subtreddit.name
    assert_equal @subtreddit.posts.where(ancestry_depth: 0), assigns(:posts)
    assert_response :success
  end

  test "should get edit" do
    skip
    get :edit, id: @subtreddit
    assert_response :success
  end

  test "should update subtreddit" do
    skip
    patch :update, id: @subtreddit, subtreddit: { description: @subtreddit.description, name: @subtreddit.name }
    assert_redirected_to subtreddit_path(assigns(:subtreddit))
  end

  test "should destroy subtreddit" do
    skip
    assert_difference('Subtreddit.count', -1) do
      delete :destroy, id: @subtreddit
    end

    assert_redirected_to subtreddits_path
  end
end
