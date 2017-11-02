class RecipesController < ApplicationController

def index

  @search = params[:search]
  @from = (params[:from]) ? params[:from].to_i : 0
  #if this exists, take it, if not, it's 0
  @previous_from = @from - 10
  @from += 10


  if params[:search]
    @recipes = RecipeApiWrapper.search(params[:search], @from)
    #If search doesn't return anything it will return an empty array - handle in the view sending a message about that
    if @recipes.nil?
      flash[:status] = "success"
      flash[:message] = "Sorry, Edamam search engine is down."
    end
  else
    @recipes = nil
  end
end

def show
  render :index, status: :bad_request and return if params[:id].nil?
  ##ONLY can use this and when doing render or redirect and ##
  @recipe = RecipeApiWrapper.find(params[:id])

  if @recipe.nil?
    render_404
    return
  end
end

end
