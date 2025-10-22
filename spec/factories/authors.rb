FactoryBot.define do
  factory :author do
    name { Faker::Book.author }
    bio { Faker::Lorem.paragraph(sentence_count: 3) }
    active { true }
    
    trait :inactive do
      active { false }
    end
  end
end
