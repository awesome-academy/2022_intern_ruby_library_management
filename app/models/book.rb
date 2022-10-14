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

  ransack_alias :bo, :name_or_description

  scope :quantity_book, ->(amount){where("quantity > ?", amount)}

  scope :latest_books, ->{order created_at: :desc}

  scope :by_category_id, (lambda do |id|
    where(category_books: {category_id: id})
  end)

  def display_image
    image.filename.present? ? image : ""
  end

  def self.ransackable_attributes auth_object = nil
    if auth_object == :user
      %w(name description)
    else
      super
    end
  end

  def self.ransackable_scopes _auth_object = nil
    [:quantity_book]
  end
end
