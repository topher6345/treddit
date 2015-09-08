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
  test 'post belongs to a subtreddit' do
    assert_not_nil posts(:one).subtreddit
  end

  test 'post belongs to user' do
    assert_not_nil posts(:one).user
  end

  test 'post has delegate method #email' do
    assert_equal posts(:one).user.email, posts(:one).email
  end

  test 'post must have a body' do
    assert_raises(ActiveRecord::RecordInvalid) do
      Post.create! title: 'hey', body: nil, subtreddit: subtreddits(:one)
    end
  end
end
