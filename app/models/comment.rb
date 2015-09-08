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
  attr_reader :post

  # Creates a Comment for a parent post and returns created post
  def self.create!(parent:, body:, user:)

    # Wraps everything in a transaction so that Post creation and
    # incrementing comments_count on all ancestors
    # is an atomic operation
    ActiveRecord::Base.transaction do
      new(
        parent: parent,
        body: body,
        user: user
      ).create_post
       .update_ancestors_caches
       .post
    end
  end

  # Sets instance variables.
  def initialize(parent:, body:, user:)
    @parent = parent
    @body = body
    @user = user
  end

  # Creates the child post.
  def create_post
    @post = @parent.children.create! comment_params

    self
  end

  # Updates the comments count for **all ancestors**.
  def update_ancestors_caches
    @post.ancestors.each do |ancestor|
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
