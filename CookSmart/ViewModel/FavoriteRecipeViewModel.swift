////
////  FavoriteRecipeViewModel.swift
////  CookSmart
////
////  Created by Ricky Primayuda Putra on 25/11/24.
////
//
//import SwiftUI
//import CoreData
//
//class FavoriteRecipeViewModel: ObservableObject {
//    let container: NSPersistentContainer
//    @Published var favoriteRecipes: [FavoriteRecipe] = []
//    
//    init() {
//        container = NSPersistentContainer(name: "CookSmartModel")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Failed to load Core Data stack: \(error)")
//            } else {
//                print("Successfully loaded core data!")
//            }
//        }
//    }
//    
//    func fetchFavoriteRecipe(byId id: Int) -> FavoriteRecipe? {
//        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
//        
//        do {
//            let results = try container.viewContext.fetch(fetchRequest)
//            return results.first
//        } catch {
//            print("Failed to fetch favorite recipe: \(error)")
//            return nil
//        }
//    }
//    
//    func addToFavorites(recipeId: Int, title: String, image: String) {
//        let newFavorite = FavoriteRecipe(context: container.viewContext)
//        newFavorite.id = Int32(recipeId)
//        newFavorite.title = title
//        newFavorite.image = image
//        
//        saveContext()
//    }
//    
//    func removeFromFavorites(recipeId: Int) {
//        if let existingFavorite = fetchFavoriteRecipe(byId: recipeId) {
//            container.viewContext.delete(existingFavorite)
//            saveContext()
//        }
//    }
//    
//    func isFavorite(recipeId: Int) -> Bool {
//        return fetchFavoriteRecipe(byId: recipeId) != nil
//    }
//    
//    private func saveContext() {
//        do {
//            try container.viewContext.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//}
