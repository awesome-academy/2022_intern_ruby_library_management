require "rails_helper"
require "cancan/matchers"
include OrdersHelper

RSpec.describe Website::OrderController, type: :controller do
  let(:user) { FactoryBot.create :user }

  let!(:book_1) { FactoryBot.create :book }
  let!(:book_2) { FactoryBot.create :book }
  let(:order) { FactoryBot.create :order }

  before do
    sign_in user
  end

  describe "GET order#index" do
    context "with return list books" do
      it "should assigns @books" do
        allow_any_instance_of(OrdersHelper).to receive(:session_book) { [book_1.id] }
        get :index
        expect(assigns(:books)).to eq([book_1])
      end
    end

    context "with return list books fail" do
      before do
        allow(Book).to receive(:where).and_return( nil )
        get :index
      end

      it "should display flash danger" do
        expect(flash[:danger]).to eq I18n.t("book.find_error")
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST order#create" do
    context "when valid attributes successfull" do
      it "should return json @order" do
        post :create, params: {
          order: order.attributes
        }
        expect(JSON.parse(response.body)["user_id"]).to eq(order.user_id)
      end
    end

    context "with invalid attributes" do
      it "should return json @order" do
        post :create, params: {
          order: {user_id: ""}
        }
        expect(JSON.parse(response.body)["message"]).to eq I18n.t("order.fails")
      end
    end
  end

  describe "PATCH order#update" do
    context "when book found" do
      before do
        allow_any_instance_of(OrdersHelper).to receive(:add_book_to_cart) { [book_2.id] }
        patch :update, params: {id: book_2.id}
      end
      it "should display success flash add book to cart" do
        expect(flash[:success]).to eq I18n.t("order.save")
      end

      it "should redirect order index" do
        expect(response).to redirect_to order_index_path
      end
    end

    context "when book not found" do
      before do
        patch :update, params: {id: -1}
      end

      it "should display flash danger" do
        expect(flash[:danger]).to eq I18n.t("book.find_error")
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH order#destroy" do
    before do
      allow_any_instance_of(OrdersHelper).to receive(:session_book) { [book_1.id] }
      delete :destroy, params: {id: book_1.id}
    end

    it "should display flash success delete book in cart" do
      expect(flash[:success]).to eq I18n.t("order.delete_ss")
    end

    it "should redirect order index" do
      expect(response).to redirect_to order_index_path
    end
  end

  describe "PATCH order#destroy_all" do
    before do
      allow_any_instance_of(OrdersHelper).to receive(:session_book) { [book_1.id, book_2.id] }
      delete :destroy_all
    end

    it "should display flash success delete book in cart" do
      expect(flash[:success]).to eq I18n.t("order.delete_ss")
    end

    it "should redirect order index" do
      expect(response).to redirect_to order_index_path
    end
  end
end
