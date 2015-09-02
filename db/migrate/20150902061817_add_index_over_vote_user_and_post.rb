class AddIndexOverVoteUserAndPost < ActiveRecord::Migration
  def change
    remove_index :votes, column: :user_id
    remove_index :votes, column: :post_id
    add_index :votes, [:user_id, :post_id], unique: true
  end
end
