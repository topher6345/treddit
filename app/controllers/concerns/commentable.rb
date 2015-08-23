module Commentable
  extend ActiveSupport::Concern

  def create_comment
    @parent = Post.find(comment_params[:parent_post])
    @post = @parent.children
                   .create(body: comment_params[:body], user_id: current_user.id)

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

  def comment_params
    params.permit(:body, :parent_post)
  end
end
