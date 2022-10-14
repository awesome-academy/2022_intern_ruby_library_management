FactoryBot.define do
  factory :category_book, class: CategoryBook do
    category { FactoryBot.create :category }
    book { FactoryBot.create :book }
  end
end
