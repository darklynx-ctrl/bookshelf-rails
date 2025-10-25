module Types
  class QueryType < Types::BaseObject
    field :books, [Types::BookType], null: false,
      description: "Отримати список всіх книг"

    def books
      Book.includes(:author).all
    end

    field :book, Types::BookType, null: true do
      argument :id, ID, required: true
    end

    def book(id:)
      Book.find_by(id: id)
    end

    field :authors, [Types::AuthorType], null: false,
      description: "Отримати список всіх авторів"

    def authors
      Author.includes(:books).all
    end

    field :author, Types::AuthorType, null: true do
      argument :id, ID, required: true
    end

    def author(id:)
      Author.find_by(id: id)
    end
  end
end
