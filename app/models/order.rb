class Order < ApplicationRecord
  FIELD_PERMIT = %i(user_id status note_user note_admin date_start
                    date_return).freeze
  ORDER_PARAMS = [:date_start, :date_return, :note_user, :user_id, :status,
    {book_ids: [], order_details_attributes:
    [:id, :book_id, :quantity, :quantity_real]}].freeze

  enum status: {pending: 0, approved: 1, returned: 2, canceled: 3}

  after_update :update_quantity_book, if: :returned?

  belongs_to :user, ->{select %i(id name email)}
  has_many :order_details, dependent: :destroy
  has_many :books, through: :order_details
  belongs_to :user, ->{select %i(id name email)}

  accepts_nested_attributes_for :books

  validates :note_admin, presence: true

  scope :latest, ->{order updated_at: :desc}

  def send_mail_confirm_order
    OrderMailer.send_note_admin(self).deliver_now
  end

  private

  def update_quantity_book
    order_details.accept.includes(:book).find_each do |order_detail|
      quantity = order_detail.book_quantity + order_detail.quantity_real
      order_detail.book.update_column :quantity, quantity
    end
  end
end
