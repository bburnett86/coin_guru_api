class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :first_name
    add_index :users, :last_name
  end
end
