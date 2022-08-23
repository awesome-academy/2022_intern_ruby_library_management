module Admin::OrderDetailsHelper
  def render_status_order_detail status
    if status == Settings.order_detail.status.pending
      "<div class='badge bg-warning'>#{t 'pending'}</div>"
    elsif status == Settings.order_detail.status.accept
      "<div class='badge bg-success'>#{t 'accept'}</div>"
    else
      "<div class='badge bg-danger'>#{t 'disagree'}</div>"
    end
  end

  def check_to_show_action_and_quantity_real order_detail
    !order_detail.order.returned? &&
      !order_detail.order.canceled? &&
      order_detail.pending?
  end
end
