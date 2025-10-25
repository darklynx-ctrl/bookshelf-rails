FactoryBot.define do
  factory :import do
    user_email { "MyString" }
    filename { "MyString" }
    total_rows { 1 }
    created_count { 1 }
    skipped_count { 1 }
    status { "MyString" }
    error_message { "MyText" }
    started_at { "2025-10-23 16:29:59" }
    finished_at { "2025-10-23 16:29:59" }
  end
end
