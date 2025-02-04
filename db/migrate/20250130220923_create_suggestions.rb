class CreateSuggestions < ActiveRecord::Migration[7.2]
  def change
    create_table :suggestions, id: :uuid do |t|
      t.references :coin, type: :uuid, null: false, foreign_key: true
      t.string :suggestion_type, null: false
      t.references :user, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
