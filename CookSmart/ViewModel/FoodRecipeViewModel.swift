//
//  FoodRecipeViewModel.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI
import SwiftData

class FoodRecipeViewModel: ObservableObject {
    
    static let apiKey = "021a383a1fc448ad9eb0439b9fa6238b"
    
    @Published var foodRecipe: [Recipe] = []
    @Published var recommendedRecipes: [Recipe] = []
    @Published var nutrient: [Nutrient] = []
    @Published var foodRecipeDetail: RecipeDetail?
    @Published var searchRecipeResult: [SearchRecipe] = []
    @Published var generateRecipeResult: [GenerateRecipe] = []
    
    @Published var vegetarian: Bool = false
    @Published var vegan: Bool = false
    @Published var gluten: Bool = false
    @Published var keto: Bool = false
    
    @Published var staticCount: Int = 4
    
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false
    
    
    func getRandomRecipe() async {
        DispatchQueue.main.async { self.isLoading = true }
        defer { DispatchQueue.main.async { self.isLoading = false } }
        
        let url = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=\(FoodRecipeViewModel.apiKey)&number=30")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode(RecipeResult.self, from: data)
            
            DispatchQueue.main.async {
                self.foodRecipe = results.recipes
                self.recommendedRecipes = Array(results.recipes.prefix(5))
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func getNutrientById(id: Int) async {
        
        let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/nutritionWidget.json?apiKey=\(FoodRecipeViewModel.apiKey)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let nutrient = try JSONDecoder().decode(NutrientResult.self, from: data)
            
            self.nutrient = nutrient.nutrients
        } catch {
            print("Error fetching nutrient by ID: \(error.localizedDescription)")
        }
    }
    
    func searchRecipe(query: String) async {
        
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(FoodRecipeViewModel.apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResult = try JSONDecoder().decode(SearchRecipeResult.self, from: data)
            
            DispatchQueue.main.async {
                self.searchRecipeResult = decodedResult.results
            }
        } catch {
            print("Error fetching or decoding data: \(error.localizedDescription)")
        }
    }
    
    @MainActor
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
    
    func generateRecipe(query: String, filters: [String: Bool], ingredients: [String], minCalories: Double, maxCalories: Double) async {
        DispatchQueue.main.async { self.isLoading = true }
        defer { DispatchQueue.main.async { self.isLoading = false } }

        var urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(FoodRecipeViewModel.apiKey)&query=\(query)"
        
        var filterValues: [String] = []
        if filters["vegetarian"] == true { filterValues.append("vegetarian") }
        if filters["vegan"] == true { filterValues.append("vegan") }
        if filters["gluten"] == true { filterValues.append("gluten") }
        if filters["keto"] == true { filterValues.append("keto") }
        if !filterValues.isEmpty {
            urlString += "&diet=" + filterValues.joined(separator: ",")
        }
        
        if !ingredients.isEmpty {
            let ingredientFilter = ingredients.joined(separator: ",")
            urlString += "&includeIngredients=" + ingredientFilter
        }

        urlString += "&minCalories=\(Int(minCalories))&maxCalories=\(Int(maxCalories))"

        guard let url = URL(string: urlString) else { return }

        do {
            print("generated url: \(url)")
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResult = try JSONDecoder().decode(GenerateRecipeResult.self, from: data)
            
            DispatchQueue.main.async {
                self.generateRecipeResult = decodedResult.results
            }
        } catch {
            print("Error fetching or decoding data: \(error.localizedDescription)")
        }
    }



}
