class AddCoverToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :cover_data, :text
  end
end
