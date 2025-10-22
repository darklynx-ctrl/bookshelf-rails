module Api
  module V1
    class BooksController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_default_format
      
      def index
        @books = Book.includes(:author)
        
        if params[:title].present?
          @books = @books.where("title ILIKE ?", "%#{params[:title]}%")
        end
        
        if params[:author_id].present?
          @books = @books.where(author_id: params[:author_id])
        end
        
        @page = params[:page].to_i
        @page = 1 if @page < 1
        
        @per_page = params[:per_page].to_i
        @per_page = 20 if @per_page < 1
        @per_page = [100, @per_page].min
        
        @books = @books.page(@page).per(@per_page)
        
        @total_count = @books.total_count
        @total_pages = @books.total_pages
        @current_page = @books.current_page
      end
      
      def show
        @book = Book.includes(:author).find_by(id: params[:id])
        
        if @book.nil?
          render json: { error: 'Book not found' }, status: :not_found
        end
      end
      
      private
      
      def set_default_format
        request.format = :json
      end
    end
  end
end
