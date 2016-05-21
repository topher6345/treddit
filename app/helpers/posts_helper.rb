module PostsHelper

  def post_timestamps(post)
    output = ''
    output <<"#{time_ago_in_words(post.created_at)} ago"
    if post.edited?
      output << " * (last edited #{time_ago_in_words(post.updated_at)} ago)"
    end
    output
  end

  def post_user(op=nil, post)
    return post.email unless op.try(:user) == post.user
    content_tag(:span, post.email, class: "post-root-user")
  end

  def post_location(post)
    if post.link.blank?
      "(self.#{post.subtreddit.name})"
    else
      "(#{post.link})"
    end
  end

  def post_upvote(votes, id)
    if votes.include?(id)
      content_tag(:i, '', class: "fi-arrow-up post-upvote-arrow-undo", "data-id" => id)
    else
      content_tag(:i, '', class: "fi-arrow-up post-upvote-arrow", "data-id" => id)
    end
  end

  def post_link_to(post, _index)
    if post.link.blank?
      link_to "#{post.title}", post
    else
      link_to "#{post.title}", post.link, target: "_blank"
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

  def post_imgur_link(link)
    return unless link
    url = ImgurUrl::Image.new(link).url(:small)
    content_tag(:a,
      content_tag(:img, '', src: url),
      href: url
    )
  rescue ::ImgurUrl::InvalidUrl
    "no url"
  rescue
  end

  def post_imgur_image(link)
    Rails.logger.debug "computing #{link}"
    image = ImgurUrl::Image.new(link)
    url = image.url(:medium)
    res = HTTParty.get("https://api.imgur.com/3/gallery/#{image.id}")
    src = res['data']['images'][0]['link'].gsub(".jpg", "l.jpg")
    content_tag(:a, content_tag(:img, '', src: src), href: url)
  rescue => e
    Rails.logger.debug "#{res} #{e.to_s}"
    ""
  end

  def post_title(post)
    if post.link
      content_tag(:a, post.title, href: post.link)
    else
      post.title
    end
  end
end