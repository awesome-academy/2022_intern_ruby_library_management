class ReportMailer < ApplicationMailer
  def report_monthly
    @order = Order.this_month.group(:user_id)
                  .limit(Settings.user.limit_top_order)
                  .order(count_all: :desc).count
    @order_details = OrderDetail.this_month.group(:book_id)
                                .limit(Settings.book.limit_top_order)
                                .order(count_all: :desc).count
    mail to: Settings.user.mail_admin, subject: t("statistic")
  end
end
