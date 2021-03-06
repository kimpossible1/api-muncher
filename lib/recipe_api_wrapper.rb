require 'httparty'
require 'uri'

class ApiError < StandardError
end


class RecipeApiWrapper  #THIS IS THE DATA
  BASE_URL = "https://api.edamam.com/search"
  APP_ID = ENV["APP_ID"]
  APP_KEY = ENV["APP_KEY"]

  def self.search(food, from)
    url = BASE_URL + "?q=#{food}" + "&from=#{from}" "&app_id=#{APP_ID}" + "&app_key=#{APP_KEY}"

    response = self.parse_response(HTTParty.get(url))
    recipe_list = []

    if response.is_a?(Hash) && response["hits"]
      response["hits"].each do |raw_recipe|
        recipe_list << self.create_recipe(raw_recipe["recipe"])
      end
    else
      recipe_list = nil
    end
    return recipe_list
  end

  def self.find(id)
    # Need to pass the URI encoded because of the special characters in the URI.
    url = BASE_URL + "?r=#{URI.encode(id)}" + "&app_id=#{APP_ID}" + "&app_key=#{APP_KEY}"
    response = self.parse_response(HTTParty.get(url))

    recipe = nil

    if response.is_a?(Array) && response.length > 0
      recipe = self.create_recipe(response[0])
    end

    return recipe
  end


  private

  def self.parse_response(response)
    response.parsed_response rescue nil
  end

  def self.create_recipe(raw_recipe)
    return Recipe.new(
      id: raw_recipe["uri"],
      label: raw_recipe["label"],
      image: raw_recipe["image"],
      url: raw_recipe["url"],
      ingredients: raw_recipe["ingredientLines"],
      servings: raw_recipe["yield"],
      total_nutrients: [ raw_recipe["totalNutrients"]["ENERC_KCAL"],
      raw_recipe["totalNutrients"]["FAT"],
      raw_recipe["totalNutrients"]["CHOCDF"],
      raw_recipe["totalNutrients"]["FIBTG"],
      raw_recipe["totalNutrients"]["SUGAR"],
      raw_recipe["totalNutrients"]["PROCNT"],
      raw_recipe["totalNutrients"]["CHOLE"],
      raw_recipe["totalNutrients"]["NA"]
    ]
    )
  end

end
