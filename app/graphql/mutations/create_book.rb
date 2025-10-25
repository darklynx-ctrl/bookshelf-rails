module Mutations
  class CreateBook < BaseMutation
    description "Створює нову книгу"

    argument :title, String, required: true
    argument :author_id, ID, required: false
    argument :year, Integer, required: false
    argument :description, String, required: false

    field :book, Types::BookType, null: false
    field :errors, [String], null: false

    def resolve(title:, author_id: nil, year: nil, description: nil)
      book = Book.new(
        title: title,
        author_id: author_id,
        year: year,
        description: description
      )

      if book.save
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

