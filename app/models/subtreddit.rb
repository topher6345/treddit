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

class Subtreddit < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  validates_uniqueness_of :name, case_sensitive: false
end
