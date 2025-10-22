module Api
  module V1
    class AuthorsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_default_format
      
      def index
        @authors = Author.includes(:books)
        
        # Фільтр за статусом
        if params[:active].present?
          @authors = @authors.where(active: params[:active])
        end
        
        # ВИПРАВЛЕНА ПАГІНАЦІЯ
        @page = params[:page].to_i
        @page = 1 if @page < 1  # За замовчуванням 1
        
        @per_page = params[:per_page].to_i
        @per_page = 20 if @per_page < 1  # За замовчуванням 20
        @per_page = [100, @per_page].min  # Максимум 100
        
        # Застосовуємо пагінацію
        @authors = @authors.page(@page).per(@per_page)
        
        # Метадані
        @total_count = @authors.total_count
        @total_pages = @authors.total_pages
        @current_page = @authors.current_page
      end
      
      def show
        @author = Author.includes(:books).find_by(id: params[:id])
        
        if @author.nil?
          render json: { error: 'Author not found' }, status: :not_found
        end
      end
      
      private
      
      def set_default_format
        request.format = :json
      end
    end
  end
end

