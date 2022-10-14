require "rails_helper"
include SessionsHelper

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) { FactoryBot.create :user }

  before do
    sign_in admin
  end

  describe "GET admin/users#index" do
    before do
      get :index
    end

    it "assigns @users" do
      expect(assigns(:users)).to eq([admin])
    end

    it "render template index" do
      expect(response).to render_template("index")
    end
  end

  describe "GET admin/users#show" do
    it "should return data user json" do
      get :show, xhr: true, params: {id: admin.id}
      expect(JSON.parse(response.body)["code"]).to eq 200
    end
  end

  describe "PUT admin/users#update" do
    context "when user is super admin" do
      it "should return json contain code 404" do
        put :update, params: {id: admin.id}
        expect(JSON.parse(response.body)["code"]).to eq 404
      end
    end

    context "when user is not super admin" do
      it "should return json contain code 200" do
        allow_any_instance_of(User).to receive(:super_admin?).and_return(false)
        put :update, params: {id: admin.id}
        expect(JSON.parse(response.body)["code"]).to eq 200
      end
    end
  end
end
