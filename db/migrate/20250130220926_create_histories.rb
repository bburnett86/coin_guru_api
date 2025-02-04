class CreateHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :histories, id: :uuid do |t|
      t.float :price, null: false
      t.datetime :created_at, null: false
      t.references :coin, type: :uuid, null: false, foreign_key: true
    end
  end
end
