require "rails_helper"

RSpec.describe "Api::V1::Me::Auth::Sessions", type: :request do
  let(:password) { Faker::Internet.password(min_length: 12) }
  let(:user) { FactoryBot.create(:user, :confirmed, password: password) }
  let(:unlocked_redirect_url) { "http://localhost:7777" }
  let(:params) { { email: user.email, password: password, unlocked_redirect_url: unlocked_redirect_url } }

  describe "POST /api/v1/auth" do
    it "responds with status code 201" do
      post "/api/v1/auth", params: params
      expect(response).to have_http_status(:created)
    end

    it "returns the token in the body" do
      post "/api/v1/auth", params: params
      expect(json).to match({
        "success" => true,
        "data" => {
          "access_token" => an_instance_of(String),
          "expires_at" => an_instance_of(String),
          "user" => user.as_json
        }
      })
    end

    context "when the password is wrong" do
      before do
        post "/api/v1/auth", params: { email: user.email, password: "itsthewrongpassword", unlocked_redirect_url: unlocked_redirect_url }
      end

      it "responds with status code 400" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns the error in the body" do
        expect(json).to eq({ "data" => { "errors" => [ "auth_invalid" ] }, "success" => false })
      end
    end
  end
end
