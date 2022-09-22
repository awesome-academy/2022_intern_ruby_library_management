FactoryBot.define do
  factory :author do
    name{Faker::Lorem.sentence(word_count: 10)}
    gender{1}
    dob{Faker::Date.birthday(min_age: 18, max_age: 65)}
    description{Faker::Lorem.sentence(word_count: 20)}
  end
end
