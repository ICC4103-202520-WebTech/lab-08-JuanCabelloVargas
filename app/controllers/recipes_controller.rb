class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_recipe_public, only: [ :show ]
  before_action :set_owned_recipe, only: [ :edit, :update, :destroy ]

  def index
    if user_signed_in? && params[:mine].present?
      @recipes = current_user.recipes.order(created_at: :desc)
      flash.now[:alert] = "You don't have recipes." if @recipes.empty?
    else
      @recipes = Recipe.all
    end
  end

  def show
  end

  def new
    @recipe = current_user.recipes.build
  end

  def create
    recipe = current_user.recipes.build recipe_params
    if recipe.save
      redirect_to recipe_path(recipe)
    else
      redirect_to new_recipe_path
    end
  end

  def edit
  end

  def update
    if @recipe.update recipe_params
      redirect_to recipe_path(@recipe)
    else
      redirect_to edit_recipe_path(@recipe)
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipe_path
  end

  private
    def recipe_params
      params.require(:recipe).permit(:title, :content, :difficulty, :cook_time)
    end

    def set_recipe_public
      @recipe = Recipe.find(params[:id])
    end

    def set_owned_recipe
      @recipe = current_user.recipes.find(params[:id])

      unless @recipe
        redirect_to recipes_path, alert: "You do not have permission to edit or destroy"
      end
    end
end
