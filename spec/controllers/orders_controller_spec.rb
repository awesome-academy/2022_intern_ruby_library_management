require "rails_helper"
include SessionsHelper

RSpec.describe Admin::OrdersController, type: :controller do
  let(:admin) { FactoryBot.create :user }
  let!(:order_1) { FactoryBot.create :order, status: :pending }
  let!(:order_2) { FactoryBot.create :order }
  let(:order_detail) { FactoryBot.create :order_detail, order: order_1 }

  before do
    sign_in admin
  end

  describe "GET admin/orders#index" do
    it "assigns @orders" do
      get :index, xhr: true
      expect(assigns(:orders).length).to eq(2)
    end

    it "render index page" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET admin/orders#show" do
    context "when order is found" do
      context "when status order is pending" do
        it "should status order to approved" do
          get :show, xhr: true, params: {id: order_1.id}
          expect(order_1.reload.status).to eq("approved")

        end
      end

      it "assigns @orders" do
        get :show, xhr: true, params: {id: order_1.id}
        expect(assigns(:orders)).to eq([order_2, order_1])
      end

      it "assign @orders_details" do
        get :show, xhr: true, params: {id: order_1.id}
        expect(assigns(:order_details)).to eq(order_1.order_details)
      end
    end

    context "when order not found" do
      before do
        get :show, xhr: true, params: {id: -1}
      end

      it "should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("admin.orders.show.not_found_order")
      end

      it "should redirect to index" do
        expect(response).to redirect_to admin_order_path
      end
    end
  end

  describe "PATCH admin/orders#update" do
    context "with params note_admin" do
      before do
        patch :update, xhr: true, params: {
          id: order_1.id,
          order: {note_admin: "Hello"}
        }
      end

      it "should update order note admin" do
        expect(order_1.reload.note_admin).to eq("Hello")
      end

      it "should render template js update" do
        expect(response).to render_template("update")
      end
    end

    context "with params status" do
      before do
        allow_any_instance_of(Order).to receive(:send_mail_confirm_order).and_return(true)
        patch :update, xhr: true, params: {
          id: order_1.id,
          status: 2
        }
      end

      it "should status to returned" do
        expect(order_1.reload.status).to eq("returned")
      end

      it "render template js update" do
        expect(response).to render_template("update")
      end
    end
  end
end
