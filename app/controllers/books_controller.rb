class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.includes(:author).all
    
    if params[:search].present?
      @books = @books.where("title ILIKE ?", "%#{params[:search]}%")
    end
    
    if params[:sort].present?
      @books = @books.order(params[:sort])
    end
  end

  def show
  end

  def new
    @book = Book.new
    @authors = Author.order(:name)  # Або @active_authors = Author.active.order(:name)
  end

  def edit
    # ДОДАЙТЕ ЦЕЙ РЯДОК
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

  def import
  end

  def import_csv
    unless params[:file].present?
      redirect_to import_books_path, alert: 'Будь ласка, виберіть файл'
      return
    end

    unless params[:email].present?
      redirect_to import_books_path, alert: 'Будь ласка, вкажіть email'
      return
    end

    uploaded_file = params[:file]
    temp_file_path = Rails.root.join('tmp', "import_#{Time.current.to_i}_#{uploaded_file.original_filename}")
    
    File.open(temp_file_path, 'wb') do |file|
      file.write(uploaded_file.read)
    end

    import = Import.create!(
      user_email: params[:email],
      filename: uploaded_file.original_filename,
      status: 'pending',
      total_rows: 0,
      created_count: 0,
      skipped_count: 0
    )

    ImportBooksJob.perform_later(import.id, temp_file_path.to_s)

    redirect_to books_path, notice: 'Імпорт розпочато. Звіт буде надіслано на email.'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author_id, :year, :description, :cover, :remove_cover)
  end
end
