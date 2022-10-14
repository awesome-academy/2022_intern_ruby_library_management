require "rails_helper"
require "cancan/matchers"

RSpec.describe Website::HomeController, type: :controller do
  let!(:category) { FactoryBot.create :category }
  let!(:book_1) { FactoryBot.create :book }
  let!(:book_2) { FactoryBot.create :book }

  describe "GET home#index" do
    before do
      get :index
    end

    it "should assigns @categories" do
      expect(assigns(:categories)).to eq([category])
    end

    it "should assigns @books" do
      expect(assigns(:books)).to eq([book_2, book_1])
    end
  end
end
