class Admin::BooksController < AdminController
  before_action :find_book, :find_array_category, except: %i(index new create)
  before_action :find_history_order, only: :destroy
  load_and_authorize_resource

  def index
    @pagy, @books = pagy Book.latest_books,
                         items: Settings.book.max_page_book
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new book_params
    if @book.save
      flash[:message] = t "books.add_ss"
      redirect_to admin_books_path
    else
      flash.now[:danger] = t "books.error"
      render :new
    end
  end

  def show; end

  def update
    if @book.update book_params
      flash[:message] = t "books.edit_ss"
      redirect_to admin_books_path
    else
      flash.now[:danger] = t "books.error_update"
      render :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:message] = t "books.delete_ss"
    else
      flash[:danger] = t "books.delete_faild"
    end
    redirect_to admin_books_path
  end

  private

  def book_params
    params.require(:book).permit Book::BOOK_PARAM
  end

  def categories_books_params
    params.require(:book).permit category_ids: []
  end

  def find_book
    @book = Book.find_by id: params[:id]
    return if @book

    flash[:danger] = t "book.find_error"
    redirect_to admin_books_path
  end

  def find_array_category
    @arr = Array.new
    @categories = CategoryBook.find_books @book.id
    @categories.map do |item|
      @arr.push item.category_id
    end
  end

  def find_history_order
    @approved = @book.order_details.where.not status: :pending
    return if @approved.blank?

    flash[:danger] = t "books.order_approved"
    redirect_to admin_books_path
  end
end
