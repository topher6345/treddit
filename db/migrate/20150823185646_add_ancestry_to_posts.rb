class AddAncestryToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :ancestry, :string
    add_index :posts, :ancestry
  end

  def down
    remove_column :posts, :ancestry
    remove_index :posts, :ancestry
  end
end
