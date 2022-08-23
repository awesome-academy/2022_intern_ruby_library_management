User.create!(name: "caoson",
  email: "caovanson@sun-asterisk.com",
  password: "123123",
  password_confirmation: "123123",
  phone_number: "0338910238",
  admin: true)

59.times do |n|
  Publisher.create!(
    name: Faker::Book.title,
    description: Faker::Lorem.sentence(word_count: 20),
  )
end

39.times do |n|
password = "123123"
User.create!(
  name: Faker::Name.name,
  email: Faker::Internet.email,
  password: password,
  password_confirmation: password,
  description: Faker::Lorem.sentence(word_count: 20),
  phone_number: Faker::PhoneNumber.phone_number,
)
end

39.times do |n|
  Category.create!(name: "sach - #{n+1}")
end

40.times do |n|
  name = "Nguyen Van A#{n+1}"
  description = "Vui tinh, Hoa dong, yeu thien nhien"
  dob = Date.new(2000, 04, 18)
  gender = 1
  Author.create!(name: name,
    description: description,
    dob: dob,
    gender: gender,
  )
end

50.times do |n|
  user_id = 1
  status = 0
  note_user = "Mong admin duyet som cho toi"
  note_admin = "Vui long cho admin duyet yeu cau"
  date_start = DateTime.parse("08/08/2022 17:00")
  date_return = DateTime.parse("15/08/2022 17:00")
  Order.create!(
    user_id: user_id,
    status: status,
    note_user: note_user,
    note_admin: note_admin,
    date_start: date_start,
    date_return: date_return,
  )
end

10.times do |n|
  book_id = 1
  order_id = 1
  status = 0
  quantity = 2
  quantity_real = 2
  OrderDetail.create!(
    book_id: book_id,
    order_id: order_id,
    status: status,
    quantity: quantity,
    quantity_real: quantity_real,
  )
end
