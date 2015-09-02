module Upvoteable
  extend ActiveSupport::Concern
  def upvote
    post = Post.find(params[:id])
    upvote = Upvote.create! user: current_user, post: post
    render json: {status: :ok }, status: :ok
  end

  def destroy_upvote
    post = Post.find(params[:id])
    Upvote.destroy! user: current_user, post: post
    render json: {status: :ok }, status: :ok
  end
end
