require "rails_helper"
include SessionsHelper

RSpec.describe Admin::BooksController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: "super_admin") }
  let(:book_1) { FactoryBot.create :book}

  before do
    sign_in admin
  end

  describe "GET admin/book#index" do
    it "assigns @books" do
      get :index
      expect(assigns(:books)).to eq([book_1])
    end

    it "render template index" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET admin/book#new" do
    it "assigns @book" do
      get :new
      expect(assigns(:book)).to be_an_instance_of(Book)
    end
  end

  describe "POST admin/book#create" do
    context "with valid attributes" do
      before do
        post :create, params: {
          book: book_1.attributes
        }
      end

      it "should create new book" do
        change{Book.count}.by 1
      end

      it "should flash success" do
        expect(flash[:message]).to eq I18n.t("books.add_ss")
      end

      it "should create new book reponse" do
        expect(response).to redirect_to admin_books_path
      end
    end

    context "with invalid attributes" do
      before do
        post :create,params:{
          book: {name: ""}
        }
      end

      it "does not save new book" do
        change{Category.count}.by 0
      end

      it "Create failed and show flash" do
        expect(flash[:danger]).to eq I18n.t("books.error")
      end

      it "Create failed and render new view" do
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH admin/book#update" do
    context "with valid attributes" do
      before do
        patch :update, params: {
          id: book_1.id,
          book: book_1.attributes
        }
      end

      it "should flash success" do
        expect(flash[:message]).to eq I18n.t("books.edit_ss")
      end

      it "should update book reponse" do
        expect(response).to redirect_to admin_books_path
      end
    end

    context "with invalid attributes" do
      before do
        patch :update,params:{
          id: book_1.id,
          book: {name: ""}
        }
      end

      it "Update failed and show flash" do
        expect(flash[:danger]).to eq I18n.t("books.error_update")
      end

      it "Create failed and render new view" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE admin/book#destroy" do
    context "when find book not found" do
      before do
        delete :destroy,params: {id: -1}
      end

      it "should flash danger" do
        expect(flash[:danger]).to eq I18n.t("book.find_error")
      end
    end

    context "when find book founded" do
      context "when find book history order" do
        let(:book_2) { FactoryBot.create :book}
        let!(:order) { FactoryBot.create :order }
        let!(:order_detail) { FactoryBot.create :order_detail, order: order, book: book_2 }

        before do
          delete :destroy, params: {id: book_2.id}
        end

        it "cant delete book in order approved" do
          expect(flash[:danger]).to eq I18n.t("books.order_approved")
        end

        it "Delete failed and redirect to index" do
          expect(response).to redirect_to admin_books_path
        end
      end

      context "when delete book successfull" do
        before do
          delete :destroy, params: {id: book_1.id}
        end

        it "should flash success" do
          expect(flash[:message]).to eq I18n.t("books.delete_ss")
        end
      end

      context "when delete book failed" do
        it "should flash danger" do
          allow_any_instance_of(Book).to receive(:destroy).and_return(false)
          delete :destroy, params: {id: book_1.id}
          expect(flash[:danger]).to eq I18n.t("books.delete_faild")
        end
      end


    end
  end

end
