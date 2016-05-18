require 'test_helper'

class UpvotesControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test 'user must login to upvote post' do
    process :create, method: :put, params: { post_id: @post }
    assert_redirected_to new_user_session_path
  end

  test 'signed in user can upvote post' do
    sign_in users(:one)
    process :create, method: :put, params: { post_id: @post }
    assert_response :success
  end

  test 'should remove upvote that exists' do
    sign_in users(:one)

    # Add upvote
    process :create, method: :put, params: { post_id: @post }
    assert_response :success, 'Could not create upvote to test destroy upvote'

    process :destroy, method: :delete, params: { post_id: @post }
    assert_response :success
  end
end
