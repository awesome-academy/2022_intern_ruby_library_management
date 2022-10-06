FactoryBot.define do
  factory :order do
    user { FactoryBot.create :user }
    status {1}
    note_user { Faker::Lorem.sentence(word_count: 10) }
    note_admin { Faker::Lorem.sentence(word_count: 10) }
    date_start { DateTime.now.to_date }
    date_return { 2.days.from_now.to_date }
  end
end
