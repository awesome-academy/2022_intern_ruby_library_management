class Admin::OrdersController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :find_by_id, only: %i(show update)

  def index
    @orders_search = Order.ransack(params[:q],
                                   auth_object: set_ransack_auth_object)
    if @orders_search.sorts.empty?
      @orders_search.sorts = ["user_name asc", "note_user asc",
                              "note_admin asc", "date_start asc",
                              "date_return asc"]
    end
    @pagy, @orders = pagy @orders_search.result.includes(:user),
                          items: Settings.order.max_page,
                          link_extra: 'data-remote="true"'
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
      handle_send_note_admin
    else
      params.key?(:status)
      if @order.update! status: params[:status].to_i
        render :update, locals: {status: Settings.status.success,
                                 action: "change_status"}
      end
    end
  end

  private

  def set_ransack_auth_object
    current_user.super_admin? ? :super_admin : :manager
  end

  def find_by_id
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t ".not_found_order"
    redirect_to admin_order_path
  end

  def order_params
    params.require(:order).permit Order::FIELD_PERMIT
  end

  def handle_send_note_admin
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
  end
end
