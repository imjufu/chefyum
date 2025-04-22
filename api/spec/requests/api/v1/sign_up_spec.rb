require "rails_helper"

RSpec.describe "Api::V1::SignUp", type: :request do
  describe "POST /api/v1/sign-up" do
    let(:params) do
      {
        user: FactoryBot.attributes_for(:user),
        redirect_url: "http://localhost:7777"
      }
    end

    let(:action) do
      post "/api/v1/sign-up", params: params
    end

    it "responds with 201 status code" do
      action
      expect(response).to have_http_status(201)
    end

    it "creates a User" do
      expect { action }.to change(User, :count).by(+1)
    end

    it "returns the user in json" do
      action
      expect(json).to eq({ "success" => true, "data" => User.last.as_json })
    end

    context "when a params is missing" do
      let(:params) { {} }

      it "responds with 400 status code" do
        action
        expect(response).to have_http_status(400)
      end
    end

    context "when the user already exists" do
      before { User.create(params[:user]) }

      it "returns a 400 status code" do
        action
        expect(response).to have_http_status(400)
      end

      it "returns errors" do
        action
        expect(json.fetch("data").fetch("errors").first).to eq "email_taken"
      end
    end
  end
end
