require "rails_helper"
require "cancan/matchers"
include SessionsHelper

RSpec.describe Admin::HomeController, type: :controller do
  let(:admin) { FactoryBot.create :user }
  let!(:order_1) { FactoryBot.create :order }
  let!(:order_2) { FactoryBot.create :order }
  let!(:order_detail1) { FactoryBot.create :order_detail, order: order_1 }
  let!(:order_detail2) { FactoryBot.create :order_detail, order: order_2 }

  before do
    sign_in admin
  end

  describe "GET admin/home#index" do
    before do
      get :index
    end

    it "should assigns top_user_order" do
      expect(assigns(:top_user_order).keys).to eq([order_1.user_id, order_2.user_id])
    end

    it "should assigns top_book_order" do
      expect(assigns(:top_book_order).keys).to eq([order_detail1.book_id, order_detail2.book_id])
    end
  end
end
