class Website::OrderController < WebsiteController
  before_action :list_books, only: :index
  before_action :find_book, only: :update

  def index; end

  def create
    @order = Order.new order_params
    if @order.save
      render json: @order
    else
      render json: {message: t("order.fails")}
    end
  end

  def update
    add_book_to_cart @book
    flash[:success] = t "order.save"
    redirect_to order_index_path
  end

  def destroy
    delete_cart params[:id]
    flash[:success] = t "order.delete_ss"
    redirect_to order_index_path
  end

  def destroy_all
    delete_all_cart
    flash[:success] = t "order.delete_ss"
    redirect_to order_index_path
  end

  private

  def order_params
    params.require(:order).permit Order::ORDER_PARAMS
  end

  def find_book
    @book = Book.find_by id: params[:id]
    return if @book

    flash[:danger] = t "book.find_error"
    redirect_to root_path
  end

  def list_books
    @books = Book.where id: session_book
    return if @books

    flash[:danger] = t "book.find_error"
    redirect_to root_path
  end
end
