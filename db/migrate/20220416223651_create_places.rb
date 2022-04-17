class CreatePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :places do |t|
      t.string :name, null: false, default: "No name"
      t.text :address, null: false, default: "No address"
      t.float :score, null: false, default: 0.0
      t.text :description, default: "No description"
      t.references :category, null: true, foreign_key: true

      t.timestamps
    end
  end
end
