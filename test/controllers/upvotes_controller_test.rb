require 'test_helper'

class UpvotesControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test 'user must login to upvote post' do
    put :create, post_id: @post
    assert_redirected_to new_user_session_path
  end

  test 'signed in user can upvote post' do
    sign_in users(:one)
    put :create, post_id: @post
    assert_response :success
  end

  test 'should remove upvote that exists' do
    sign_in users(:one)

    # Add upvote
    put :create, post_id: @post
    assert_response :success, 'Could not create upvote to test destroy upvote'

    delete :destroy, post_id: @post
    assert_response :success
  end
end
