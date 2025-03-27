require 'rails_helper'

RSpec.describe "Api::V1::Me", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:auth_headers) { { 'Authorization': 'Bearer ' + user.generate_token_for(:access_token) } }

  describe "GET /api/v1/me" do
    it 'responds with status code 401' do
      get '/api/v1/me'
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when the user is logged in' do
      before { get '/api/v1/me', headers: auth_headers }

      it 'responds with status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user in json' do
        expect(json).to eq({ 'data' => user.as_json(
          { only: [ :id, :name, :email, :unconfirmed_email, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip ] }
        ), 'success' => true })
      end
    end
  end
end
