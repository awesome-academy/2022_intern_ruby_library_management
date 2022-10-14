FactoryBot.define do
  factory :order_detail do
    order { FactoryBot.create :order }
    book { FactoryBot.create :book }
    status {1}
    quantity {2}
    quantity_real {2}
  end
end
