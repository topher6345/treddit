class AddDefaultValueToPostVotes < ActiveRecord::Migration
  def change
    change_column :posts, :votes, :integer, default: 0
    Post.where(votes: nil).each { |post| post.update!(votes: 0) }
  end
end
