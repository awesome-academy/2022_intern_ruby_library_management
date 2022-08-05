class Book < ApplicationRecord
  BOOK_PARAM = [:name, :image, :description,
              :author_id, :publisher_id, :quantity,
              {category_ids: [], category_books_attributes:
              [:id, :book_id, :category_id]}].freeze
  belongs_to :author
  belongs_to :publisher
  has_many :category_books, dependent: :destroy
  has_many :categories, through: :category_books
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  has_one_attached :image
  accepts_nested_attributes_for :category_books, :order_details

  delegate :name, :dob, to: :author, prefix: true
  delegate :name, :description, to: :publisher, prefix: true

  validates :name, presence: true, length: {minimum: Settings.book.min}
  validates :description, presence: true,
            length: {minimum: Settings.book.min}
  validates :quantity, presence: true, numericality: {only_integer: true}

  scope :latest_books, ->{order created_at: :desc}

  scope :by_category_id, (lambda do |id|
    where(category_books: {category_id: id})
  end)

  scope :by_order, ->(id){where(order_details: {order_id: id})}

  scope :select_order, (lambda do
    select "books.*,order_details.quantity,
            order_details.status,order_details.quantity_real"
  end)
  scope :search_book_name, (lambda do |name|
    where("name LIKE ?", "%#{name}%") if name.present?
  end)
  scope :search_category, (lambda do |category|
    if category.present?
      joins(:category_books).where("category_books.category_id=?", category)
    end
  end)
  scope :search_author, (lambda do |author|
    where(author_id: author) if author.present?
  end)
  def display_image
    image.filename.present? ? image : ""
  end
end
