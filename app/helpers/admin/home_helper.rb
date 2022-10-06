module Admin::HomeHelper
  def render_chart_top_user_order top_user_order
    data_chart = {}
    top_user_order.each do |user_id, times_order|
      user = User.find_by(id: user_id)
      next if user.blank?

      newkey = user.name
      data_chart[newkey] = times_order
    end
    data_chart
  end

  def render_chart_top_book_order top_book_order
    data_chart = {}
    top_book_order.each do |book_id, times_order|
      book = Book.find_by(id: book_id)
      next if book.blank?

      newkey = book.name
      data_chart[newkey] = times_order
    end
    data_chart
  end
end
