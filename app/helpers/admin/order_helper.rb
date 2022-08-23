module Admin::OrderHelper
  def render_status_order status
    html = []
    html << if status == Settings.order.status.approved
              "<div class='badge bg-info'>approved</div>".html_safe
            elsif status == Settings.order.status.returned
              "<div class='badge bg-success'>returned</div>".html_safe
            elsif status == Settings.order.status.canceled
              "<div class='badge bg-danger'>canceled</div>".html_safe
            else
              "<div class='badge bg-warning'>pending</div>".html_safe
            end

    safe_join(html)
  end
end
