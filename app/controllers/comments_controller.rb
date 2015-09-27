# = CommentsController
#
# This class defines actions to comment on Posts.

class CommentsController < ApplicationController
  # Sets an instance variable to interact with an existing Post record.
  before_action :set_post, only: [:create]

  # Endpoint to create a comment or 'child Post' of an existing parent post.
  def create
    @comment = Comment.new comment_params

    respond_to do |format|
      if @comment.save!
        format.html { redirect_to @post.root, notice: 'Post was successfully created.' }
        # format.json { render :show, status: :created, location: @post }
      else
        format.html { redirect_to @post.root, notice: 'Error: Comment was not made.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end

  rescue ActiveModel::StrictValidationFailed => e
    # render :new, notice: @comment.errors
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  # Defines whitelisted parameters accepted by this action.
  def comment_params
    params.permit(:body).merge( parent: @post, user: current_user )
  end
end
