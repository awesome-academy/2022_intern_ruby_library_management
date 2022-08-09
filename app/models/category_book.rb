class CategoryBook < ApplicationRecord
  has_many :categories_books, dependent: :destroy
  has_many :books, through: :categories_books

  validates :name, presence: true, length: {minimum: Settings.book.min}

  scope :latest_category, ->{order created_at: :desc}
end
