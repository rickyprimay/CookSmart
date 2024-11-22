//
//  FoodRecipeViewModel.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

class FoodRecipeViewModel: ObservableObject {
    
    static let apiKey = "08d9bcc6db1845e0a189cebd76c95e3c"
    
    @Published var foodRecipe: [Recipe] = []
    @Published var nutrient: [Nutrient] = []
    @Published var foodRecipeDetail: RecipeDetail?
    @Published var searchRecipeResult: [Recipe] = []
    
    func getRandomRecipe() async {
        let url = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=\(FoodRecipeViewModel.apiKey)&number=5")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let results = try JSONDecoder().decode(RecipeResult.self, from: data)
            
            DispatchQueue.main.async {
                self.foodRecipe = results.recipes
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func search(term: String) async {
        let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(FoodRecipeViewModel.apiKey)?query\(term)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let results = try JSONDecoder().decode(RecipeResult.self, from: data)
            
            DispatchQueue.main.async {
                self.searchRecipeResult = results.recipes
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func getNutrientById(id: Int) async {
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/nutritionWidget.json?apiKey=\(FoodRecipeViewModel.apiKey)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let nutrient = try JSONDecoder().decode(NutrientResult.self, from: data)
            
            DispatchQueue.main.async {
                self.nutrient = nutrient.nutrients
            }
        } catch {
            print("Error fetching nutrient by ID: \(error.localizedDescription)")
        }
    }
    
    func getRecipeByFilter(vegetarian: Bool, vegan: Bool, glutenFree: Bool, dairyFree: Bool, ingredients: [String]) async {
            var urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(FoodRecipeViewModel.apiKey)"
            
            if vegetarian {
                urlString += "&diet=vegetarian"
            }
            if vegan {
                urlString += "&diet=vegan"
            }
            if glutenFree {
                urlString += "&diet=glutenFree"
            }
            if dairyFree {
                urlString += "&diet=dairyFree"
            }
            
            if !ingredients.isEmpty {
                let ingredientsParam = ingredients.joined(separator: ",")
                urlString += "&includeIngredients=\(ingredientsParam)"
            }
            
            let url = URL(string: urlString)!
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let results = try JSONDecoder().decode(RecipeResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.foodRecipe = results.recipes
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    
    func getRecipeById(id: Int) async {
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/information?apiKey=\(FoodRecipeViewModel.apiKey)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let recipeDetail = try JSONDecoder().decode(RecipeDetail.self, from: data)
            
            DispatchQueue.main.async {
                self.foodRecipeDetail = recipeDetail
            }
            await getNutrientById(id: id)
        } catch {
            print("Error fetching recipe by ID: \(error.localizedDescription)")
        }
    }
}
