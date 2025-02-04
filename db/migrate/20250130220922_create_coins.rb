class CreateCoins < ActiveRecord::Migration[7.2]
  def change
    create_table :coins, id: :uuid do |t|
      t.string :name, null: false
      t.string :image_url
      t.text :description
      t.string :symbol, null: false
      t.string :thumb_image_url
      t.string :small_image_url
      t.string :large_image_url
      t.string :homepage
      t.timestamps
    end
    add_index :coins, :name, unique: true
    add_index :coins, :symbol, unique: true
  end
end