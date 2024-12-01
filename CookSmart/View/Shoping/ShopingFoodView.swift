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
    @StateObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#FFF6E9")
                    .ignoresSafeArea()
                
                VStack {
                    if shoping.isEmpty {
                        VStack {
                            Image(systemName: "cart.fill.badge.minus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding(.bottom, 16)
                            
                            Text("Belum Ada Belanjaan")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 8)
                            
                            Text("Mulailah dengan menambahkan bahan makanan ke dalam daftar belanjaan Anda!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                        .padding()
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
            guard authViewModel.isLoggedIn else {
                print("User is not logged in")
                return
            }
            let userUID = authViewModel.currentUser.uid
            shoping = SQLiteManager.shared.getAllShoppingItems(forUser: userUID)
        }
    
    private func deleteShopingItem(id: Int) {
        SQLiteManager.shared.deleteShoppingItem(byId: id)
        loadShoping()
    }
}
