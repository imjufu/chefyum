class V1::CookingRecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_cooking_recipe, only: %i[ show update destroy ]
  authorize_resource

  # GET /cooking_recipes
  def index
    @pagy, @cooking_recipes = pagy(CookingRecipe.all)

    render json: success_response(@cooking_recipes)
  end

  # GET /cooking_recipes/1
  def show
    render json: success_response(@cooking_recipe.as_json(with_ingredients: true, with_nutritional_values: true))
  end

  # POST /cooking_recipes
  def create
    @cooking_recipe = CookingRecipe.new(cooking_recipe_params)

    if @cooking_recipe.save
      render json: success_response(@cooking_recipe.as_json), status: :created
    else
      render json: error_response(@cooking_recipe.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cooking_recipes/1
  def update
    if @cooking_recipe.update(cooking_recipe_params)
      render json: success_response(@cooking_recipe)
    else
      render json: error_response(@cooking_recipe.errors), status: :unprocessable_entity
    end
  end

  # DELETE /cooking_recipes/1
  def destroy
    @cooking_recipe.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cooking_recipe
    @cooking_recipe = CookingRecipe.find_by(slug: params.expect(:slug))
  end

  # Only allow a list of trusted parameters through.
  def cooking_recipe_params
    params.require(:cooking_recipe).permit(:title, :description, steps: [ [ :step, :instruction ] ])
  end
end
