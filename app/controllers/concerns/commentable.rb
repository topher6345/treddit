# = Commentable
#
# This module adds an action to create a comment for a post.
#
# A comment is another instance of a Post that is not a root.
# In other words, a comment is a child Post of another Post.
module Commentable
  extend ActiveSupport::Concern

  # Endpoint to create a comment or 'child Post' of an existing parent post.
  def create_comment
    @parent = Post.find(comment_params[:parent_post])
    @post = @parent.children.create(children_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @parent.root, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @parent }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Defines whitelisted parameters accepted by this action.
  def comment_params
    params.permit(:body, :parent_post)
  end

  # Defines whitelisted parameters needed to create a comment or child Post.
  def children_params
    { body: comment_params[:body],
      user_id: current_user.id,
      subtreddit_id: @parent.subtreddit_id}
  end
end
