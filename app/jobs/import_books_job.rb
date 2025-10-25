require 'csv'

class ImportBooksJob < ApplicationJob
  queue_as :default

  def perform(import_id, csv_file_path)
    import = Import.find(import_id)
    import.update(status: 'processing', started_at: Time.current)
    
    created_count = 0
    skipped_count = 0
    errors = []

    begin
      # Читаємо CSV файл
      CSV.foreach(csv_file_path, headers: true, header_converters: :symbol) do |row|
        import.increment!(:total_rows)
        
        # Парсимо дані
        title = row[:title]&.strip
        author_name = row[:author_name]&.strip
        year = row[:year]&.to_i
        description = row[:description]&.strip

        # Валідація обов'язкових полів
        if title.blank?
          skipped_count += 1
          errors << "Рядок #{import.total_rows}: відсутня назва"
          next
        end

        # Знаходимо автора (якщо вказано)
        author = nil
        if author_name.present?
          author = Author.find_by("name ILIKE ?", author_name)
          
          unless author
            skipped_count += 1
            errors << "Рядок #{import.total_rows}: автор '#{author_name}' не знайдено"
            next
          end
        end

        # Створюємо книгу
        book = Book.new(
          title: title,
          author: author,
          year: year,
          description: description
        )

        if book.save
          created_count += 1
        else
          skipped_count += 1
          errors << "Рядок #{import.total_rows}: #{book.errors.full_messages.join(', ')}"
        end
      end

      # Зберігаємо результати
      import.update(
        status: 'completed',
        created_count: created_count,
        skipped_count: skipped_count,
        error_message: errors.join("\n"),
        finished_at: Time.current
      )

      # Відправляємо email зі звітом
      UserMailer.import_report(import).deliver_later

    rescue => e
      import.update(
        status: 'failed',
        error_message: e.message,
        finished_at: Time.current
      )
      
      # Відправляємо email про помилку
      UserMailer.import_report(import).deliver_later
    ensure
      # Видаляємо тимчасовий файл
      File.delete(csv_file_path) if File.exist?(csv_file_path)
    end
  end
end

