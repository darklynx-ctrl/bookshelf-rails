json.data do
  json.author do
    json.id @author.id
    json.name @author.name
    json.bio @author.bio
    json.active @author.active
    
    json.books do
      json.array! @author.books do |book|
        json.id book.id
        json.title book.title
        json.year book.year
      end
    end
  end
end
