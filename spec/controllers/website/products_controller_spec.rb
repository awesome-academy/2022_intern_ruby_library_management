require "rails_helper"
require "cancan/matchers"

RSpec.describe Website::ProductsController, type: :controller do
  let!(:book) { FactoryBot.create :book }
  let!(:category_book) { FactoryBot.create :category_book, book: book }

  describe "GET products#index" do
    it "should assigns @book" do
      get :index
      expect(assigns(:book)).to eq([book])
    end
  end

  describe "GET products#show" do
    context "when product found" do
      before do
        get :show, params: {id: book.id}
      end

      it "should assign category books" do
        expect(assigns(:category_books)).to eq([category_book])
      end
    end

    context "when product not found" do
      before do
        get :show, params: {id: -1}
      end

      it "should display flash danger" do
        expect(flash[:danger]).to eq I18n.t("website.products.not_found_book")
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
