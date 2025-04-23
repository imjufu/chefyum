require "rails_helper"

RSpec.describe "Api::V1::CookingRecipes", type: :request do
  let(:cooking_recipe) { FactoryBot.create(:cooking_recipe) }
  let(:user) { FactoryBot.create(:user) }
  let(:auth_headers) { { 'Authorization': "Bearer " + user.generate_token_for(:access_token) } }

  describe "GET /api/v1/cooking-recipes" do
    before do
      cooking_recipe
      get "/api/v1/cooking-recipes"
    end

    it "responds with status code 200" do
      expect(response).to have_http_status(:ok)
    end

    it "returns a list of cooking recipes" do
      expect(json).to eq({
        "success" => true,
        "data" => [ cooking_recipe.as_json ]
      })
    end

    it "returns a paginated list" do
      expect(response.headers).to include(
        "current-page" => "1",
        "page-items" => "20",
        "total-count" => "1",
        "total-pages" => "1"
      )
    end
  end

  describe "GET /api/v1/cooking-recipes/:slug" do
    before do
      cooking_recipe
      get "/api/v1/cooking-recipes/#{cooking_recipe.slug}"
    end

    it "responds with status code 200" do
      expect(response).to be_successful
    end

    it "returns the cooking recipe with details" do
      expect(json).to eq({
        "success" => true,
        "data" => cooking_recipe.as_json(with_ingredients: true, with_nutritional_values: true)
      })
    end
  end

  describe "POST /api/v1/cooking-recipes" do
    let(:valid_attributes) { FactoryBot.attributes_for(:cooking_recipe) }
    let(:invalid_attributes) { valid_attributes.merge(title: nil) }

    it "responds with status code 401" do
      post "/api/v1/cooking-recipes", params: { cooking_recipe: valid_attributes }
      expect(response).to have_http_status(:unauthorized)
    end

    context "when the user is logged in" do
      it "responds with status code 401" do
        post "/api/v1/cooking-recipes", params: { cooking_recipe: valid_attributes }, headers: auth_headers
        expect(response).to have_http_status(:unauthorized)
      end

      context "when the user is an admin" do
        before { user.update(profile: User::PROFILES[:admin]) }

        context "with valid parameters" do
          it "creates a new cooking recipe" do
            expect do
              post "/api/v1/cooking-recipes", params: { cooking_recipe: valid_attributes }, headers: auth_headers
            end.to change(CookingRecipe, :count).by(1)
          end

          it "responds with status code 201" do
            post "/api/v1/cooking-recipes", params: { cooking_recipe: valid_attributes }, headers: auth_headers
            expect(response).to have_http_status(:created)
          end

          it "returns the cooking recipe in json" do
            post "/api/v1/cooking-recipes", params: { cooking_recipe: valid_attributes }, headers: auth_headers
            expect(json).to eq({
              "success" => true,
              "data" => CookingRecipe.last.as_json
            })
          end
        end

        context "with invalid parameters" do
          it "does not create a new cooking recipe" do
            expect {
              post "/api/v1/cooking-recipes", params: { cooking_recipe: invalid_attributes }, headers: auth_headers
            }.to change(CookingRecipe, :count).by(0)
          end

          it "responds with status code 422" do
            post "/api/v1/cooking-recipes", params: { cooking_recipe: invalid_attributes }, headers: auth_headers
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end

  describe "PATCH /api/v1/cooking-recipes/:slug" do
    let(:new_title) { Faker::Food.dish }
    let(:valid_attributes) { { title: new_title } }
    let(:invalid_attributes) { { title: nil } }

    it "responds with status code 401" do
      patch "/api/v1/cooking-recipes/#{cooking_recipe.slug}", params: { cooking_recipe: valid_attributes }
      expect(response).to have_http_status(:unauthorized)
    end

    context "when the user is logged in" do
      it "responds with status code 401" do
        patch "/api/v1/cooking-recipes/#{cooking_recipe.slug}", params: { cooking_recipe: valid_attributes }, headers: auth_headers
        expect(response).to have_http_status(:unauthorized)
      end

      context "when the user is an admin" do
        before { user.update(profile: User::PROFILES[:admin]) }

        context "with valid parameters" do
          it "updates the requested cooking recipe" do
            old_title = cooking_recipe.title
            expect do
              patch "/api/v1/cooking-recipes/#{cooking_recipe.slug}", params: { cooking_recipe: valid_attributes }, headers: auth_headers
              cooking_recipe.reload
            end.to change(cooking_recipe, :title).from(old_title).to(new_title)
          end

          it "responds with status code 200" do
            patch "/api/v1/cooking-recipes/#{cooking_recipe.slug}", params: { cooking_recipe: valid_attributes }, headers: auth_headers
            expect(response).to have_http_status(:ok)
          end

          it "returns the cooking recipe in json" do
            patch "/api/v1/cooking-recipes/#{cooking_recipe.slug}", params: { cooking_recipe: valid_attributes }, headers: auth_headers
            cooking_recipe.reload
            expect(json).to eq({
              "success" => true,
              "data" => cooking_recipe.as_json
            })
          end
        end

        context "with invalid parameters" do
          it "responds with status code 422" do
            patch "/api/v1/cooking-recipes/#{cooking_recipe.slug}", params: { cooking_recipe: invalid_attributes }, headers: auth_headers
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end

  describe "DELETE /api/v1/cooking-recipes/:slug" do
    before { cooking_recipe }

    it "responds with status code 401" do
      delete "/api/v1/cooking-recipes/#{cooking_recipe.slug}"
      expect(response).to have_http_status(:unauthorized)
    end

    context "when the user is logged in" do
      it "responds with status code 401" do
        delete "/api/v1/cooking-recipes/#{cooking_recipe.slug}", headers: auth_headers
        expect(response).to have_http_status(:unauthorized)
      end

      context "when the user is an admin" do
        before { user.update(profile: User::PROFILES[:admin]) }

        it "destroys the requested cooking recipe" do
          expect do
            delete "/api/v1/cooking-recipes/#{cooking_recipe.slug}", headers: auth_headers
          end.to change(CookingRecipe, :count).by(-1)
        end

        it "responds with status code 204" do
          delete "/api/v1/cooking-recipes/#{cooking_recipe.slug}", headers: auth_headers
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end
end
