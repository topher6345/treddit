module Upvoteable
  extend ActiveSupport::Concern
  def upvote
    post = Post.find(params[:id])
    upvote = Upvote.create! user: current_user, post: post
    redirect_to posts_path(post), status: :ok
  end
end
