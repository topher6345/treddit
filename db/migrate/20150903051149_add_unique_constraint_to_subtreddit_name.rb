class AddUniqueConstraintToSubtredditName < ActiveRecord::Migration
  def change
    change_column :subtreddits, :name, :string, unique: true
  end
end
