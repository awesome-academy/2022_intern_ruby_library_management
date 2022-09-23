require "rails_helper"
include SessionsHelper

RSpec.describe Admin::AuthorsController, type: :controller do
  let(:author_1){
    FactoryBot.create :author
  }

  describe "GET admin/author#index" do
    it "assign @authors" do
      get :index
      expect(assigns(:authors)).to eq([author_1])
    end

    it "render the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET admin/author#new" do
    it "assign @author" do
      get :new, xhr: true
      expect(response).to render_template("show_form")
    end
  end

  describe "POST admin/author#create" do
    context "when valid attributes successfull" do
      before do
        post :create, xhr: true, params: {
            author: {name: "Hoa", gender: "male",
                    dob: Date.today, description: "Hòa đồng"},
        }
      end

      it "should display message flash" do
        expect(response).to render_template("update")
      end

      it "status success" do
        expect(assigns(:status)).to eq true
      end
    end

    context "when create author failed with wrong value" do
      before do
        post :create, xhr: true, params: {
            author: {name: "", gender: "",
              dob: "", description: ""},
        }
      end

      it "should display message flash" do
        expect(response).to render_template("update")
      end

      it "status failed" do
        expect(assigns(:status)).to eq false
      end
    end
  end

  describe "PATCH admin/author#update" do
    context "when update author successfully" do
      before do
        patch :update, xhr:true, params: {
            id: author_1.id,
            author: {name: "Hoa2", gender: "male",
                    dob: Date.today, description: "Hòa đồng"},
          }
      end

      it "should display message flash" do
        expect(response).to render_template("update")
      end

      it "status success" do
        expect(assigns(:status)).to eq true
      end

    end

    context "when update author failed" do
      before do
        patch :update, xhr: true, params: {
            id: author_1.id,
            author: {name: "", gender: "",
              dob: "", description: ""},
        }
      end

      it "should display message flash" do
        expect(response).to render_template("update")
      end

      it "status failed" do
        expect(assigns(:status)).to eq false
      end
    end
  end

  describe "GET amdin/author#edit" do
    context "When author is not found" do
      before do
        get :edit, xhr:true, params:{
          id: -11
        }
      end

      it "should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("admin.authors.edit.not_found_author")
      end
    end

    context "When author is found" do
      before do
        get :edit, xhr: true, params:{
          id: author_1.id
        }
      end

      it "should show author" do
        expect(response).to render_template("show_form")
      end
    end
  end

  describe "DELETE admin/author#destroy" do
    context "When author is not found" do
      before do
        delete :destroy, xhr: true, params:{
          id: -1
        }
      end

      it "should display danger flash" do
        expect(flash[:danger]).to eq I18n.t("admin.authors.destroy.not_found_author")
      end
    end

    context "When delete author successfull" do
      before do
        delete :destroy, params:{
          id: author_1.id
        }
      end

      it "should render json" do
        expect(response).to have_http_status 200
      end
    end

    context "When delete author failed" do
      before do
        delete :destroy, params:{
          id: ""
        }
      end

      it "should render json" do
        expect(response).to have_http_status 302
      end
    end
  end

end
