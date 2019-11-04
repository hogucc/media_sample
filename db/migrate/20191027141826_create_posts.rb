class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, limit: 20, null: false
      t.string :image, null: false
      t.string :content, limit: 140, null: false

      t.timestamps
    end
  end
end
