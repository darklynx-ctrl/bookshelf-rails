require 'rails_helper'

RSpec.describe Book, type: :model do
  describe "associations" do
    it { should belong_to(:author).optional }
  end

  describe "validations" do
    # ВИПРАВЛЕНО: вказуємо кастомне повідомлення
    it { should validate_presence_of(:title).with_message("повинна бути заповнена") }
    
    it "validates year range" do
      book = build(:book, year: 1400)
      expect(book).not_to be_valid
      
      book.year = 2000
      expect(book).to be_valid
    end
  end

  describe "scopes" do
    let!(:book1) { create(:book, title: "Кобзар") }
    let!(:book2) { create(:book, title: "Заповіт") }

    it "search_by_title знаходить книги" do
      results = Book.search_by_title("Кобзар")
      expect(results).to include(book1)
      expect(results).not_to include(book2)
    end
  end
end
