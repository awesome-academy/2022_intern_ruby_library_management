require "rails_helper"
require "cancan/matchers"
include SessionsHelper

RSpec.describe Website::UsersController, type: :controller do
  let(:user) {FactoryBot.create :user}

  before do
    sign_in user
  end

  describe "PATCH users#update" do
    it "should user update successfully" do
      patch :update, params: {
        id: user.id,
        user: {name: "Hoa"}
      }

      expect(response).to redirect_to user_path(user)
    end
  end

  describe "GET users#show" do
    context "when user not found" do
      before do
        get :show, params: {id: -1}
      end

      it "should display flash dange" do
        expect(flash[:danger]).to eq I18n.t("users.no_user")
      end

      it "should redirect to " do
        expect(response).to redirect_to user_path(user)
      end
    end
  end

end
