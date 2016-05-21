module Broadcastable
  include ActiveSupport::Concern

  def broadcast_new_post(post)
    html = ApplicationController.render partial:  'stream/index/post', locals: { post: post }
    WebNotificationsChannel.broadcast_to('all', html)
  end
end
