FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    year { rand(1500..2030) }
    description { Faker::Lorem.paragraph }
    association :author
    
    trait :without_author do
      author { nil }
    end
  end
end
