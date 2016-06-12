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
  extend Forwardable
  def_delegators :@comment, 
    :messages, :errors, :link, :subtreddit, :title, :created_at, :parent, 
    :root, :body, :id, :cache_key, :ancestors, :siblings, :email, :descendants_depth

  # Creates a Comment for a parent post and returns created post
  def self.create!(attributes)
    new(attributes).save!
  end

  # Sets instance variables.
  def initialize(parent:, body:, user:)
    @children       = parent.children
    @comment_params = {
      body:          body,
      user_id:       user.id,
      subtreddit_id: parent.subtreddit_id
    }
  end

  def save!
    ActiveRecord::Base.transaction do
      @comment = create_post! @comment_params
      update_ancestors! @comment.ancestors
    end
    fail unless @comment
    @comment
  end

  # Creates the child post.
  def create_post!(params)
    @children.create! params
  end

  # Updates the comments count for **all ancestors**.
  def update_ancestors!(ancestors)
    ancestors.each do |post|
      post.touch
      post.increment(:descendants_depth).save!
    end
  end

  def to_model
    Post
  end
end
