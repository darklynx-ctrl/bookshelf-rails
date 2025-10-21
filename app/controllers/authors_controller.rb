class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  def index
    @authors = Author.includes(:books).order(:name)
  end

  def show
    @author = Author.includes(:books).find(params[:id])
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    
    respond_to do |format|
      if @author.save
        format.html { redirect_to new_book_path(author_id: @author.id), notice: 'Автора успішно створено!' }
        format.js # Для AJAX запиту
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js # Для відображення помилок
      end
    end
  end

  def edit
  end

  def update
    if @author.update(author_params)
      redirect_to @author, notice: 'Автора успішно оновлено.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @author.destroy
      redirect_to authors_url, notice: 'Автора успішно видалено.'
    else
      redirect_to authors_url, alert: @author.errors.full_messages.join(', ')
    end
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :bio, :active)
  end
end

