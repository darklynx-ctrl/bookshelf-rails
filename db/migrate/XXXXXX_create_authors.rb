class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :bio
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
