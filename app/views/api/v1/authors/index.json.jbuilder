json.data do
  json.authors do
    json.array! @authors do |author|
      json.id author.id
      json.name author.name
      json.bio author.bio
      json.active author.active
      json.books_count author.books.count
    end
  end
end

json.pagination do
  json.current_page @current_page
  json.per_page @per_page
  json.total_count @total_count
  json.total_pages @total_pages
  json.has_next_page @current_page < @total_pages
  json.has_prev_page @current_page > 1
end
