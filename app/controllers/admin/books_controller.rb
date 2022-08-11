class Admin::BooksController < AdminController
  before_action :logged_in_user
  before_action :find_book, :find_array_category, except: %i(index new create)

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
      @book.category build_params
      flash[:message] = t "books.add_ss"
      redirect_to admin_books_path
    else
      flash[:danger] = t "books.error"
      render :new
    end
  end

  def show; end

  def update
    if @book.update book_params
      @categories.destroy_all
      @book.category build_params
      flash[:message] = t "books.add_ss"
      redirect_to admin_books_path
    else
      flash.now[:danger] = t "books.error"
      render :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:message] = t "books.delete_ss"
      redirect_to admin_books_path
    else
      flash[:message] = t "books.delete_faild"
    end
    redirect_to admin_books_path
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

  def find_book
    @book = Book.find_by id: params[:id]
    return if @book

    store_location
    redirect_to admin_books_path
    flash[:danger] = t "book.find_error"
  end

  def find_array_category
    @arr = Array.new
    @categories = CategoriesBook.where book_id: @book.id
    @categories.map do |item|
      @arr.push item.category_book_id
    end
  end
end
