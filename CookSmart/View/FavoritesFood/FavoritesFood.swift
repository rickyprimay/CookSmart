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
            ZStack {
                Color(hex: "#FFF6E9")
                    .ignoresSafeArea()
                if favoriteFoods.isEmpty {
                    VStack {
                        Image(systemName: "star.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.yellow)
                            .padding(.bottom, 16)
                        
                        Text("Belum ada resep favorit.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 8)
                        
                        Text("Mulailah menambahkan resep yang Anda sukai ke daftar favorit untuk mempermudah pencarian!")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    VStack {
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
            }
            .onAppear {
                loadFavorites()
            }
            .navigationTitle("Resep Favorit")
            .background(Color(hex: "#FFF6E9"))
        }
    }
    
    private func loadFavorites() {
        DispatchQueue.main.async {
            favoriteFoods = SQLiteManager.shared.getAllFavorites()
        }
    }
}
