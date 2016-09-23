# = CommentsController
#
# This class defines actions to comment on Posts.

class CommentsController < ApplicationController
  # Allow post to broadcast new posts
  include Broadcastable

  # Sets an instance variable to interact with an existing Post record.
  before_action :set_post

  # Redirects to login page if no User session exists.
  before_action :authenticate_user!

  def new
  end

  # Endpoint to create a comment or 'child Post' of an existing parent post.
  def create
    @comment = create_comment

    respond_to do |format|
      if @comment.save!
        @post.touch && @comment.ancestors.each(&:touch)

        broadcast_new_post @comment
        dom_id = "/#H#{@comment.id}"

        format.html { redirect_to post_path(@post.root)+dom_id, notice: 'Post was successfully created.' }
        # format.json { render :show, status: :created, location: @post }
      else
        format.html { redirect_to post_path(@post.root), notice: 'Error: Comment was not made.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end

  rescue ActiveRecord::RecordInvalid => e
    redirect_to post_path(@post.root), notice: e.message
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  # Defines whitelisted parameters accepted by this action.
  def comment_params
    params.permit(:body).merge(parent: @post, user: current_user)
  end

  def create_comment
    Comment.create!(
      body:   comment_params[:body],
      parent: comment_params[:parent],
      user:   comment_params[:user]
    )
  end
end
