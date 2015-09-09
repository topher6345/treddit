# = Upvoteable
#
# This module adds actions to upvote, or undo an existing upvote for a post.

module Upvoteable
  extend ActiveSupport::Concern

  # Defines an endpoint to add an upvote to an existing Post.
  def upvote
    post = Post.find(params[:id])
    Upvote.create! user: current_user, post: post
    render json: {status: :ok }, status: :ok
  end

  # Defines an endpoint to undo an existing upvote to an existing Post.
  def destroy_upvote
    post = Post.find(params[:id])
    Upvote.destroy_all! user: current_user, post: post
    render json: {status: :ok }, status: :ok
  end
end
