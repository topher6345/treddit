require 'test_helper'

class CreatePostFlowTest < ActionDispatch::IntegrationTest
  test 'can create post' do
    get root_path
    assert_equal 200, status
    assert_select 'title', 'Treddit-A clone of the front page of the internet'

    post user_session_path, user: {
      email: users(:one).email, password: TEST_PASSWORD }
    follow_redirect!
    assert_select '.top-bar-section' do
      assert_select 'a', 'Logged in as user1@treddit.com'
    end

    get new_post_path
    assert_equal 200, status

    post posts_path, post: {
      body: 'stuff here',
      subtreddit_id: subtreddits(:one).id,
      title: users(:one).email
    }
    follow_redirect!
    assert_equal 200, status
  end
end
