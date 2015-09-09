class AddEditedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :edited, :boolean, default: false
  end
end
