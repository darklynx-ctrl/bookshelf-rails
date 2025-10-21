class AddAuthorIdToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :author, foreign_key: true, index: true
  end
end
