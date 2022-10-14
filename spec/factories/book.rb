FactoryBot.define do
  factory :book do
    name {Faker::Lorem.sentence(word_count: 10)}
    description {Faker::Lorem.sentence(word_count: 20)}
    quantity {10}
    author {FactoryBot.create :author}
    publisher {FactoryBot.create :publisher}
  end
end
