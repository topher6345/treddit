module CommentsHelper
  def comments(count)
    return "#{count} comments" if count != 1
    '1 comment'
  end

  # highlight OP, regular everyone else
  def user_highlight(post, user)
    if post.root.user == user
      return content_tag(:span, user.email, class: 'post-original-poster')
    else
      user.email
    end
  end
end