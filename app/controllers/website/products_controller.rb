class Website::ProductsController < WebsiteController
  before_action :find_by_id, :find_comment, only: :show

  def index
    @book = Book.all
    render json: @book
  end

  def show
    @category_books = @book.category_books
    @com = Comment.new
  end

  private

  def find_by_id
    @book = Book.find_by id: params[:id]
    return if @book

    flash[:danger] = t "website.products.not_found_book"
    redirect_to root_path
  end

  def find_comment
    @comments = Comment.latest.find_comment params[:id]
    return if @comments
  end
end
