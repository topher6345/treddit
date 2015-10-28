module PostsHelper

  def post_timestamps(post)
    output = ''
    output <<"#{time_ago_in_words(post.created_at)} ago"
    if post.edited?
      output << " * (last edited #{time_ago_in_words(post.updated_at)} ago)"
    end
    output
  end

  def post_user(op, post)
    if op.user == post.user
      content_tag(:span, post.email, class: "post-root-user")
    else
      post.email
    end
  end

  def post_location(post)
    if post.link.blank?
      "(self)"
    else
      post.link
    end
  end

  def post_upvote(votes, id)
    if votes.include?(id)
      content_tag(:i, '', class: "fi-arrow-up post-upvote-arrow-undo", "data-id" => id)
    else
      content_tag(:i, '', class: "fi-arrow-up post-upvote-arrow", "data-id" => id)
    end
  end

  def post_link_to(post, index)
    if post.link.blank?
      link_to "#{index} #{post.title}", post
    else
      link_to "#{index} #{post.title}", post.link, target: "_blank"
    end
  end

  def post_aside(post)
    output = "".html_safe
    if post.link.blank?
      output << "to "
      output << link_to("tr/#{post.subtreddit.name}", pretty_subtreddit_path(post.subtreddit.name))
    end
    output
  end
end