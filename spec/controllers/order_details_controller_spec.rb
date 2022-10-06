require "rails_helper"
require "cancan/matchers"
include SessionsHelper

RSpec.describe Admin::OrderDetailsController, type: :controller do
  let(:admin) { FactoryBot.create :user }
  let(:order_detail) { FactoryBot.create :order_detail, status: 0 }

  before do
    sign_in admin
  end

  describe "PATCH admin/order_details#update" do
    context "when order detail is found" do
      context "when update status order detail" do
        it "should update status order detail" do
          patch :update, xhr: true, params: {
            id: order_detail.id,
            status: "accept"
          }
          expect(order_detail.reload.status).to eq("accept")
        end
      end

      context "when update quantity real order detail" do
        it "should update quantity real order detail" do
          patch :update, xhr: true, params: {
            id: order_detail.id,
            quantity_real: 1
          }
          expect(order_detail.reload.quantity_real).to eq(1)
        end
      end
    end

    context "when order detail is not found" do
      before do
        patch :update, xhr: true, params: {
          id: -1,
          status: "accept"
        }
      end

      it "should display flash danger" do
        expect(flash[:danger]).to eq I18n.t("admin.order_details.not_found_order_detail")
      end

      it "should redirect to index order" do
        expect(response).to redirect_to admin_orders_path
      end
    end
  end
end
