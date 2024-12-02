class RemoveCategoryFromEvent < ActiveRecord::Migration[6.1]
  def change
    remove_reference :events, :category, null: false, foreign_key: true
  end
end
