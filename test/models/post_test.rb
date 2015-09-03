# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  title          :string
#  body           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  link           :string
#  user_id        :integer          not null
#  votes          :integer          default(0)
#  subtreddit_id  :integer          not null
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "post belongs to a subtreddit" do
    assert_not_nil posts(:one).subtreddit
  end
end
