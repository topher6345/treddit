# = Comment
#
# This class is a factory for creating a comment.
#
# Usage
#
#    Comment.create! parent: @post, body: 'My comment.', user: current_user
#
# A comment is represented by the database as a row in the `posts` table.
# This row has a 'parent' post through the ancestry gem.
#
# A parent post has a denormalized field `descendants_depth`
# through which it caches the count of its descendant posts(a.k.a. total comments)

class Comment
  # Public method to access created post.
  include ActiveModel::Validations

  attr_accessor :parent, :user, :body
  validates!    :parent, :user, :body, presence: true

  # Creates a Comment for a parent post and returns created post
  def self.create!(attributes)
    new(attributes).save!
  end

  # Sets instance variables.
  def initialize(attributes={})
    @parent = attributes[:parent]
    @body = attributes[:body]
    @user = attributes[:user]
  end

  def save!
    ActiveRecord::Base.transaction do
      valid?
      create_post
      update_ancestors_caches
    end

    @comment
  end

  # Creates the child post.
  def create_post
    @comment = @parent.children.create! comment_params

    self
  end

  # Updates the comments count for **all ancestors**.
  def update_ancestors_caches
    @comment.ancestors.each do |ancestor|
      ancestor.increment(:descendants_depth)
      ancestor.save!
    end

    self
  end

  private

  # The parameters needed to create a Post AR model.
  def comment_params
    @comment_params ||= {
      body: @body,
      user_id: @user.id,
      subtreddit_id: @parent.subtreddit_id
    }
  end
end
