class OrderMailer < ApplicationMailer
  def send_note_admin order
    @user = order.user
    @note_admin = order.note_admin
    mail to: @user.email, subject: t("admin.auths.mail.title_send_note_admin")
  end
end
