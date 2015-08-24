module CommentsHelper
  def comments(count)
    return "#{count} comments" if count != 1
    '1 comment'
  end
end