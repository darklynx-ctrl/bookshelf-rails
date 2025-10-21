class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :bio
      t.boolean :active

      t.timestamps
    end
  end
end
