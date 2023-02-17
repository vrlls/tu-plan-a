class AddEventRefToReviews < ActiveRecord::Migration[6.1]
  def change
    add_reference :reviews, :event, null: true, foreign_key: true
  end
end
