class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  def index
    @books = Book.all.order(created_at: :desc)
  end

  # GET /books/:id
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    
    if @book.save
      redirect_to @book, notice: 'Книгу успішно створено!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /books/:id/edit
  def edit
  end

  # PATCH/PUT /books/:id
  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Книгу успішно оновлено!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Книгу успішно видалено!'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :year, :description)
  end
end
