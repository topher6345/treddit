class AddSubtredditToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :subtreddit, index: true, foreign_key: true, null: false
  end
end
