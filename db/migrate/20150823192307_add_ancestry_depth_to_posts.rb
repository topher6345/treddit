class AddAncestryDepthToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :ancestry_depth, :integer, :default => 0
  end
end
