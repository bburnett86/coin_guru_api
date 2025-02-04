class CreateReferences < ActiveRecord::Migration[7.2]
  def change
    create_table :references, id: :uuid do |t|
      t.string :url, null: false
      t.text :description, null: false
      t.references :reason, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
