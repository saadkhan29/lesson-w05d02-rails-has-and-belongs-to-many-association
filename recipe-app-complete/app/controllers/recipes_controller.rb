class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    render json: @recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    # This code below has a quick demo of how to form a json object with nested ingredients on a recipe.
    # render json: @recipe, include: :ingredients
  end

  def new
    @recipe = Recipe.new
  end

  def create
    puts params
    @recipe = Recipe.create(recipe_params)
    redirect_to @recipe
  end

  private

    def recipe_params
      params.require(:recipe).permit(:name, :ingredient_ids => [])
    end
end