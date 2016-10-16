# == Schema Information
#
# Table name: posts
#
#  id                :integer          not null, primary key
#  title             :string
#  body              :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ancestry          :string
#  ancestry_depth    :integer          default(0)
#  link              :string
#  user_id           :integer          not null
#  votes             :integer          default(0)
#  subtreddit_id     :integer          not null
#  descendants_depth :integer          default(0)
#  edited            :boolean          default(FALSE)
#

# = Post
#
# A post is the foundational record of Treddit.
#
# Posts can be viewed as nodes in a hierarchal tree data structure.
#
#   https://en.wikipedia.org/wiki/Tree_(data_structure)
#
# Posts can be roots (OP or original posts.)
# or can be comments (Posts whos parent node is another Post.)
class Post < ActiveRecord::Base
  searchable do
    text :body, stored: true
  end
  # Caches how many descendants (comments) a Post may have
  #
  #   https://github.com/stefankroes/ancestry#options-for-has_ancestry
  #
  has_ancestry cache_depth: true

  # Defines a Post (or comment) must have some content
  validates :body, presence: true

  # Defines relationship between Post and User
  belongs_to :user

  has_many :votes

  # Defines relationship between Post and Subtreddit, so that
  # Posts can be viewed by Subtreddit.
  #
  #   https://en.wikipedia.org/wiki/Reddit#Subreddits
  #
  belongs_to :subtreddit

  # Convenience method that a Post can display what User wrote the post.
  delegate :email, to: :user

  # Queries all comments for a post
  def comments
    descendants.arrange(order: 'votes DESC')
  end
end
