module Mutations
  class UpdateBook < BaseMutation
    description "Оновлює існуючу книгу"

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :author_id, ID, required: false
    argument :year, Integer, required: false
    argument :description, String, required: false

    field :book, Types::BookType, null: true
    field :errors, [String], null: false

    def resolve(id:, **attributes)
      book = Book.find_by(id: id)

      if book.nil?
        return {
          book: nil,
          errors: ["Book not found"]
        }
      end

      if book.update(attributes.compact)
        {
          book: book,
          errors: []
        }
      else
        {
          book: nil,
          errors: book.errors.full_messages
        }
      end
    end
  end
end
