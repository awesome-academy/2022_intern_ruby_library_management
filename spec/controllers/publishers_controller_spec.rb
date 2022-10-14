require "rails_helper"
include SessionsHelper

RSpec.describe Admin::PublishersController, type: :controller do
  let(:admin) { FactoryBot.create(:user, role: "super_admin") }

  let!(:publisher_1) { FactoryBot.create(:publisher) }

  before do
    sign_in admin
  end

  describe "GET admin/publisher#index" do
    it "assign @publishers" do
      get :index
      expect(assigns(:publishers)).to eq([publisher_1])
    end

    it "render template index" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET admin/publisher#new" do
    it "render template show_form format js" do
      get :new, xhr: true
      expect(response).to render_template("show_form")
    end
  end

  describe "GET admin/publisher#edit" do
    context "when publisher is not found" do
      before do
        get :edit, xhr: true, params: {
          id: -1
        }
      end

      it "should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("admin.publishers.not_found_publisher")
      end
    end

    context "when publisher is found" do
      before do
        get :edit, xhr: true, params: { id: publisher_1.id }
      end

      it "should show form edit publisher" do
        expect(response).to render_template("show_form")
      end
    end
  end

  describe "POST admin/publisher#create" do
    context "when valid attributes successfully" do
      before do
        post :create, xhr: true, params: {
          publisher: {
            name: Faker::Name.unique.name,
            description: Faker::Lorem.sentence(word_count: 5)
          }
        }
      end

      it "render template update format js" do
        expect(response).to render_template("update")
      end

      it "status success" do
        expect(assigns(:status)).to eq true
      end
    end

    context "when invalid attributes failed" do
      before do
        post :create, xhr: true, params: {
          publisher: {name: "", description: ""}
        }
      end

      it "render template update format js" do
        expect(response).to render_template("update")
      end

      it "status failed" do
        expect(assigns(:status)).to eq false
      end
    end
  end

  describe "POST admin/publisher#update" do
    context "when valid attributes successfully" do
      before do
        post :update, xhr: true, params: {
          id: publisher_1.id,
          publisher: {
            name: Faker::Name.unique.name,
            description: Faker::Lorem.sentence(word_count: 5)
          }
        }
      end

      it "render template update format js" do
        expect(response).to render_template("update")
      end

      it "status success" do
        expect(assigns(:status)).to eq true
      end
    end

    context "when invalid attributes failed" do
      before do
        post :update, xhr: true, params: {
          id: publisher_1.id,
          publisher: {name: "", description: ""}
        }
      end

      it "render template update format js" do
        expect(response).to render_template("update")
      end

      it "status failed" do
        expect(assigns(:status)).to eq false
      end
    end
  end

  describe "DELETE admin/publisher#destroy" do
    context "when publisher not found" do
      before do
        delete :destroy, xhr: true, params: {id: -1}
      end

      it "should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("admin.publishers.destroy.not_found_publisher")
      end
    end

    context "When delete publisher successfull" do
      before do
        delete :destroy, params:{
          id: publisher_1.id
        }
      end

      it "should render json with code success" do
        expect(JSON.parse(response.body)["code"]).to eq 200
      end
    end

    context "When delete publisher failed" do

      it "should render json with code fail" do
        allow_any_instance_of(Publisher).to receive(:destroy).and_return(false)
        delete :destroy, params:{
          id: publisher_1.id
        }
        expect(JSON.parse(response.body)["code"]).to eq 302
      end
    end
  end

end
