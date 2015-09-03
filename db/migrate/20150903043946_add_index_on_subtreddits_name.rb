class AddIndexOnSubtredditsName < ActiveRecord::Migration
  def change
    add_index(:subtreddits, :name)
  end
end
