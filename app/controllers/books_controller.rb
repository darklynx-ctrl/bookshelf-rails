class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.includes(:author).all
    
    # Пошук по назві
    if params[:search].present?
      @books = @books.where("title ILIKE ?", "%#{params[:search]}%")
    end
    
    # Сортування
    if params[:sort].present?
      @books = @books.order(params[:sort])
    end
  end

  def show
  end

  def new
    @book = Book.new
    @authors = Author.order(:name)  
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: 'Книгу успішно створено.'
    else
      @authors = Author.order(:name) 
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @authors = Author.order(:name)  
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Книгу успішно оновлено.'
    else
      @authors = Author.order(:name) 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Книгу успішно видалено.'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author_id, :year, :description)
  end
end

