class Admin::BooksController < AdminController
  before_action :logged_in_user

  def index
    @pagy, @books = pagy Book.latest_books,
                         items: Settings.max_page_user
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new book_params
    if @book.save
      @book.category build_params
      flash[:message] = t "books.add_ss"
      redirect_to admin_books_path
    else
      flash[:danger] = t "books.error"
      render :new
    end
  end

  private

  def book_params
    params.require(:book).permit :name, :image, :description,
                                 :author_id, :publisher_id, :quantity
  end

  def categories_books_params
    params.require(:book).permit category_book_ids: []
  end

  def build_params
    arr = categories_books_params
    arr[:category_book_ids].shift
    arr[:category_book_ids].map do |category_book_id|
      {category_book_id: category_book_id}
    end
  end
end
