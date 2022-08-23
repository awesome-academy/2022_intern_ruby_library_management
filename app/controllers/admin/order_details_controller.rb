class Admin::OrderDetailsController < ApplicationController
  # before_action :logged_in_user
  before_action :find_by_id, only: %i(update)

  def update
    if params.key?(:status)
      status_sent_to = params[:status]

      @order_detail.update! status: OrderDetail.statuses[status_sent_to]
      @order_detail.update_quantity_book if @order_detail.accept?
      render :update,
             locals: {order_detail: @order_detail, action: "change_status"}
    elsif params.key?(:quantity_real)
      update_quantity_real params[:quantity_real]
      render :update,
             locals: {order_detail: @order_detail,
                      action: "change_quantity-real"}
    end
  end

  private

  def find_by_id
    @order_detail = OrderDetail.find_by id: params[:id]
    return if @order_detail

    flash[:danger] = t ".not_found_order_detail"
    redirect_to admin_orders_path
  end
end
