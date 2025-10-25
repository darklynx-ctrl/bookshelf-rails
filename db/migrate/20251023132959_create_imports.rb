class CreateImports < ActiveRecord::Migration[8.0]
  def change
    create_table :imports do |t|
      t.string :user_email
      t.string :filename
      t.integer :total_rows
      t.integer :created_count
      t.integer :skipped_count
      t.string :status
      t.text :error_message
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
