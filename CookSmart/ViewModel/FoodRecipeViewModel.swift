//
//  FoodRecipeViewModel.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI
import SwiftData

class FoodRecipeViewModel: ObservableObject {
    
    static let apiKey = "8fa6512cab104f2583449f27b920c67b"
    
    @Published var foodRecipe: [Recipe] = []
    @Published var nutrient: [Nutrient] = []
    @Published var foodRecipeDetail: RecipeDetail?
    @Published var searchRecipeResult: [SearchRecipe] = []
    
    @Published var vegetarian: Bool = false
    @Published var vegan: Bool = false
    @Published var gluten: Bool = false
    @Published var keto: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false

    
    func getRandomRecipe() async {
        DispatchQueue.main.async { self.isLoading = true }
        defer { DispatchQueue.main.async { self.isLoading = false } }
        
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
    
    func generateRecipe(query: String, filters: [String: Bool]) async {
        DispatchQueue.main.async { self.isLoading = true }
        defer { DispatchQueue.main.async { self.isLoading = false } }
        
        var urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(FoodRecipeViewModel.apiKey)&query=\(query)"
        
        var filterValues: [String] = []
        
        if filters["vegetarian"] == true {
            filterValues.append("vegetarian")
        }
        if filters["vegan"] == true {
            filterValues.append("vegan")
        }
        if filters["gluten"] == true {
            filterValues.append("gluten")
        }
        if filters["keto"] == true {
            filterValues.append("keto")
        }
        
        if !filterValues.isEmpty {
            urlString += "&diet=" + filterValues.joined(separator: ",")
        }
        
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
}
