//
//  ShopingFoodView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 26/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShopingFoodView: View {
    @State private var shoping: [Shoping] = []
    @StateObject var viewModel = FoodRecipeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(hex: "#FFF6E9")
                    .ignoresSafeArea()
                VStack {
                    if shoping.isEmpty {
                        Text("No Shopping Yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(shoping, id: \.id) { food in
                                    HStack {
                                        ShopingListItemView(shoping: food)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            deleteShopingItem(id: food.id)
                                        }) {
                                            Image(systemName: "trash")
                                                .font(.title2)
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Color.white.cornerRadius(10).shadow(radius: 3))
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            
            .onAppear {
                loadShoping()
            }
            .navigationTitle("Bahan Baku")
            .background(Color(hex: "#FFF6E9").ignoresSafeArea())
        }
    }
    
    private func loadShoping() {
        shoping = SQLiteManager.shared.getAllShoppingItems()
    }
    
    private func deleteShopingItem(id: Int) {
        SQLiteManager.shared.deleteShoppingItem(byId: id)
        loadShoping()
    }
}
