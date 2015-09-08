class AddDescendentsDepthToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :descendants_depth, :integer, default: 0
  end
end
