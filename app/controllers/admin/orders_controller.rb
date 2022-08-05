class Admin::OrdersController < ApplicationController
  layout "admin"
  # before_action :logged_in_user
  before_action :find_by_id, only: %i(show update)

  def index
    @pagy, @orders = pagy Order.latest.includes(:user),
                          items: Settings.order.max_page
  end

  def show
    if @order.pending?
      @order.update! status: Order.statuses.key(Settings.order.status.approved)
    end
    @pagy, @orders = pagy Order.latest,
                          items: Settings.order.max_page
    @order_details = @order.order_details.includes(:book)
  end

  def update
    if params.dig(:order, :note_admin)
      if @order.update! note_admin: params[:order][:note_admin]
        @pagy, @orders = pagy Order.latest,
                              items: Settings.order.max_page
        @order.send_mail_confirm_order
        render :update, locals: {status: Settings.status.success,
                                 action: "change_note_admin"}
      else
        render :update, locals: {status: Settings.status.internal_server_error,
                                 action: "change_note_admin"}
      end
    else
      params.key?(:status)
      if @order.update! status: params[:status].to_i
        render :update, locals: {status: Settings.status.success,
                                 action: "change_status"}
      end
    end
  end

  private

  def find_by_id
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t ".not_found_order"
    redirect_to admin_order_path
  end

  def order_params
    params.require(:order).permit Order::FIELD_PERMIT
  end
end
