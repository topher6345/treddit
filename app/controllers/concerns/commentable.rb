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
    @post = Post.find(params[:id])
    @comment = Comment.new create_comment_params

    respond_to do |format|
      if @comment.save!
        format.html { redirect_to @post.root, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end

  rescue ActiveModel::StrictValidationFailed => e
    render :new, notice: @comment.errors
  end

  private

  # Defines whitelisted parameters accepted by this action.
  def comment_params
    params.permit(:body)
  end

  # Defines whitelisted parameters needed to create a comment or child Post.
  def create_comment_params
    { parent: @post, body: comment_params[:body], user: current_user }
  end
end
