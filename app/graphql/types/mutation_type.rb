# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :update_book, mutation: Mutations::UpdateBook
    field :create_book, mutation: Mutations::CreateBook
    field :delete_book, mutation: Mutations::DeleteBook
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
