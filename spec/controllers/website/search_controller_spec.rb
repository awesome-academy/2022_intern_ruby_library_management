require "rails_helper"
require "cancan/matchers"

RSpec.describe Website::SearchController, type: :controller do
  let(:admin) { FactoryBot.create :user }
  let!(:book_1) { FactoryBot.create :book, name: "dac" }
  let!(:book_2) { FactoryBot.create :book }

  before do
    sign_in admin
  end

  describe "GET search#index" do
    it "should assigns @books" do
      get :index
      expect(assigns(:books).length).to eq(2)
    end
  end

  describe "GET search#show" do
    it "should assigns @books" do
      get :show, xhr: true, params: {
        q: {name_cont: "dac"}
      }
      expect(assigns(:books)).to eq([book_1])
    end
  end
end
