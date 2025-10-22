json.data do
  json.book do
    json.id @book.id
    json.title @book.title
    json.year @book.year
    json.description @book.description
    json.created_at @book.created_at.iso8601
    json.updated_at @book.updated_at.iso8601
    
    # Детальна інформація про автора
    if @book.author
      json.author do
        json.id @book.author.id
        json.name @book.author.name
        json.bio @book.author.bio
        json.active @book.author.active
        json.books_count @book.author.books.count
      end
    else
      json.author nil
    end
  end
end
