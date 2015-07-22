class CreateJoinTableUserTasteCategory < ActiveRecord::Migration
  def change
    create_join_table :users, :taste_categories do |t|
      t.index [:user_id, :taste_category_id]
      t.index [:taste_category_id, :user_id]
    end
  end
end
