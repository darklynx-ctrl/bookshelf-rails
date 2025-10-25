module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false 
    field :title, String, null: false
    field :year, Integer, null: true
    field :description, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    
    # Зв'язок з автором
    field :author, Types::AuthorType, null: true
  end
end
