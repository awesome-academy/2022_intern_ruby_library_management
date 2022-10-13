class Admin::HomeController < AdminController
  authorize_resource class: false

  def index
    @top_user_order = Order.this_month.group(:user_id)
                           .limit(Settings.user.limit_top_order)
                           .order(count_all: :desc).count

    @top_book_order = OrderDetail.this_month.group(:book_id)
                                 .limit(Settings.book.limit_top_order)
                                 .order(count_all: :desc).count
  end
end
