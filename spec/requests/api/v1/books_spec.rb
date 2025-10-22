require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  # Створюємо тестові дані перед кожним тестом
  let!(:author) { create(:author, name: "Тарас Шевченко") }
  let!(:book1) { create(:book, title: "Кобзар", year: 1840, author: author) }
  let!(:book2) { create(:book, title: "Гайдамаки", year: 1841, author: author) }
  let!(:book3) { create(:book, title: "Заповіт", year: 1845, author: nil) }

  describe "GET /api/v1/books" do
    context "без параметрів" do
      it "повертає всі книги зі статусом 200" do
        get "/api/v1/books"
        
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        
        expect(json['data']['books'].size).to eq(3)
        expect(json['pagination']).to be_present
      end
      
      it "має правильну структуру JSON" do
        get "/api/v1/books"
        
        json = JSON.parse(response.body)
        book = json['data']['books'].first
        
        expect(book).to have_key('id')
        expect(book).to have_key('title')
        expect(book).to have_key('year')
        expect(book).to have_key('author')
      end
    end

    context "пошук за назвою" do
      it "знаходить книги по частковому співпадінню" do
        get "/api/v1/books", params: { title: "Кобзар" }
        
        json = JSON.parse(response.body)
        expect(json['data']['books'].size).to eq(1)
        expect(json['data']['books'][0]['title']).to eq("Кобзар")
      end
      
      it "повертає порожній масив якщо нічого не знайдено" do
        get "/api/v1/books", params: { title: "Неіснуюча книга" }
        
        json = JSON.parse(response.body)
        expect(json['data']['books']).to be_empty
      end
      
      it "пошук нечутливий до регістру" do
        get "/api/v1/books", params: { title: "кобзар" }
        
        json = JSON.parse(response.body)
        expect(json['data']['books'].size).to eq(1)
      end
    end

    context "фільтрація за автором" do
      it "повертає тільки книги вказаного автора" do
        get "/api/v1/books", params: { author_id: author.id }
        
        json = JSON.parse(response.body)
        expect(json['data']['books'].size).to eq(2)
        
        json['data']['books'].each do |book|
          expect(book['author']['id']).to eq(author.id)
        end
      end
      
      it "повертає порожній масив для неіснуючого автора" do
        get "/api/v1/books", params: { author_id: 99999 }
        
        json = JSON.parse(response.body)
        expect(json['data']['books']).to be_empty
      end
    end

    context "пагінація" do
      before do
        create_list(:book, 25)  # Створюємо 25 додаткових книг
      end

      it "повертає вказану кількість записів" do
        get "/api/v1/books", params: { per_page: 10 }
        
        json = JSON.parse(response.body)
        expect(json['data']['books'].size).to eq(10)
        expect(json['pagination']['per_page']).to eq(10)
      end
      
      it "повертає правильну сторінку" do
        get "/api/v1/books", params: { page: 2, per_page: 10 }
        
        json = JSON.parse(response.body)
        expect(json['pagination']['current_page']).to eq(2)
      end
      
      it "обмежує максимальну кількість на сторінку" do
        get "/api/v1/books", params: { per_page: 200 }
        
        json = JSON.parse(response.body)
        expect(json['data']['books'].size).to be <= 100
      end
      
      it "вказує чи є наступна сторінка" do
        get "/api/v1/books", params: { page: 1, per_page: 10 }
        
        json = JSON.parse(response.body)
        expect(json['pagination']['has_next_page']).to be true
      end
    end

    context "комбінація фільтрів" do
      it "пошук + автор + пагінація" do
        create(:book, title: "Кобзар молодий", author: author)
        
        get "/api/v1/books", params: { 
          title: "Кобзар",
          author_id: author.id,
          per_page: 5
        }
        
        json = JSON.parse(response.body)
        expect(json['data']['books'].size).to be >= 1
        json['data']['books'].each do |book|
          expect(book['title']).to include("Кобзар")
          expect(book['author']['id']).to eq(author.id)
        end
      end
    end
  end

  describe "GET /api/v1/books/:id" do
    context "коли книга існує" do
      it "повертає книгу зі статусом 200" do
        get "/api/v1/books/#{book1.id}"
        
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        
        expect(json['data']['book']['id']).to eq(book1.id)
        expect(json['data']['book']['title']).to eq("Кобзар")
      end
      
      it "включає детальну інформацію про автора" do
        get "/api/v1/books/#{book1.id}"
        
        json = JSON.parse(response.body)
        author_data = json['data']['book']['author']
        
        expect(author_data).to have_key('bio')
        expect(author_data).to have_key('books_count')
      end
    end

    context "коли книга не існує" do
      it "повертає 404 статус" do
        get "/api/v1/books/99999"
        
        expect(response).to have_http_status(:not_found)
      end
      
      it "повертає повідомлення про помилку" do
        get "/api/v1/books/99999"
        
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Book not found')
      end
    end
  end
end
