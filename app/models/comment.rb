class Comment
  def self.create!(parent:, body:, user:)
    new(
      parent: parent,
      body: body,
      user: user
    ).create_post
     .update_parent_cache
  end

  def initialize(parent:, body:, user:)
    @parent = parent
    @body = body
    @user = user
  end

  def create_post
    @parent.children.create! comment_params
    self
  end

  def update_parent_cache
    @parent.increment(:comments_count)
    @parent.save!
    self
  end

  private

  def comment_params
    @comment_params ||= {
      body: @body,
      user_id: @user.id,
      subtreddit_id: @parent.subtreddit_id
    }
  end
end
