//
//  FavoritesFood.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 25/11/24.
//

import SwiftUI
import SDWebImageSwiftUI 

struct FavoritesFoodView: View {
    @State private var favoriteFoods: [FavoriteFood] = []
    @StateObject var viewModel = FoodRecipeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if favoriteFoods.isEmpty {
                    Text("No Favorites Yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(favoriteFoods, id: \.idRecipe) { food in
                                NavigationLink(destination: DetailFood(
                                    viewModel: viewModel,
                                    idRecipe: food.idRecipe
                                )) {
                                    RecipeFavoriteListItemView(foodRecipe: food)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                loadFavorites()
            }
            .navigationTitle("Resep Favorit")
            .background(Color(hex: "#FFF6E9"))
//            .ignoresSafeArea()
        }
    }
    
    private func loadFavorites() {
        DispatchQueue.main.async {
            favoriteFoods = SQLiteManager.shared.getAllFavorites()
        }
    }
}
