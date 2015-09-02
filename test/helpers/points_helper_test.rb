require 'test_helper'

class PointsHelperTest < ActionView::TestCase
  include PointsHelper

  test "should proper pluralization" do

    assert_equal '0 points', points(0)
    assert_equal '1 point', points(1)
    assert_equal '2 points', points(2)

  end

end