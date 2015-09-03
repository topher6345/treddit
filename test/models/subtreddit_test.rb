# == Schema Information
#
# Table name: subtreddits
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class SubtredditTest < ActiveSupport::TestCase
  test 'subtreddit has many posts' do
    assert_not_empty subtreddits(:one).posts
  end
end
