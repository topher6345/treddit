class CreateSubtreddits < ActiveRecord::Migration
  def change
    create_table :subtreddits do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
