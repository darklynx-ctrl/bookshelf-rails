require "shrine"
require "shrine/storage/file_system"

# Налаштування сховищ
Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # Тимчасові файли
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")        # Постійні файли
}

# Плагіни
Shrine.plugin :activerecord           # Інтеграція з ActiveRecord
Shrine.plugin :cached_attachment_data # Кешування
Shrine.plugin :restore_cached_data    # Відновлення даних з кешу
Shrine.plugin :validation_helpers     # Валідація файлів
Shrine.plugin :determine_mime_type    # Визначення MIME типу
