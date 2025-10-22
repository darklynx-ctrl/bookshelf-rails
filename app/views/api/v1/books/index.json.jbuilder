json.data do
  json.books do
    json.array! @books do |book|
      json.id book.id
      json.title book.title
      json.year book.year
      json.description book.description
      json.created_at book.created_at
      json.updated_at book.updated_at
      
      if book.author
        json.author do
          json.id book.author.id
          json.name book.author.name
          json.active book.author.active
        end
      else
        json.author nil
      end
    end
  end
end

json.pagination do
  json.current_page @current_page
  json.per_page @per_page
  json.total_count @total_count
  json.total_pages @total_pages
  # ДОДАНО: has_next_page та has_prev_page
  json.has_next_page @current_page < @total_pages
  json.has_prev_page @current_page > 1
end
