class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.float :score, null:false, default: 5.0
      t.string :title, null:false, default: "No title"
      t.text :comment, null:false, default: "No comment"
      t.references :user, null: false, foreign_key: true
      t.references :place, null: true, foreign_key: true

      t.timestamps
    end
  end
end
