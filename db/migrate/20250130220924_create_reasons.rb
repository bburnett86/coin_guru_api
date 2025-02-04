class CreateReasons < ActiveRecord::Migration[7.2]
  def change
    create_table :reasons, id: :uuid do |t|
      t.string :type, null: false
      t.references :suggestion, type: :uuid, null: false, foreign_key: true
      t.text :description, null: false
      t.timestamps
    end
  end
end
