class OrderDetail < ApplicationRecord
  enum status: {pending: 0, accept: 1, disagree: 2}

  belongs_to :order
  belongs_to :book

  validates :quantity_real, presence: true,
    numericality: {greater_than: 0, message: I18n.t("must_greater_0")}
  validate :quantity_real_cannot_be_greater_than_quantity_book, on: :update
  delegate :name, :image, :quantity, to: :book, prefix: true
  scope :status_accept, ->(status){where status: status}

  def update_quantity_book
    return unless quantity_real < book_quantity

    book.update quantity: book_quantity - quantity_real
  end

  def update_quantity_real action_quantity_real
    if action_quantity_real == Settings.order_detail.quantity_real.inscrese
      update quantity_real: quantity_real + 1
    else
      update quantity_real: quantity_real - 1
    end
  end

  private

  def quantity_real_cannot_be_greater_than_quantity_book
    return unless quantity_real > book_quantity && accept?

    errors.add(:quantity_real, I18n.t("cannot_be_greater_than_quantity_book"))
  end
end
