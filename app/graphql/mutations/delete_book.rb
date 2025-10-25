module Mutations
  class DeleteBook < BaseMutation
    description "Видаляє книгу"

    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      book = Book.find_by(id: id)

      if book.nil?
        return {
          success: false,
          errors: ["Book not found"]
        }
      end

      if book.destroy
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: book.errors.full_messages
        }
      end
    end
  end
end

