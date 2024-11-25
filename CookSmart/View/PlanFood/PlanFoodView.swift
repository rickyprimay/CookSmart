//
//  PlanFoodView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 22/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlanFoodView: View {
    @State private var planFood: [PlanFood] = []
    @StateObject var viewModel = FoodRecipeViewModel()
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    @State private var endDate: Date = Date()
    @State private var totalCalories: Float = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#FFF6E9")
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                        
                        Text("-")
                        
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                        
                        Button("Terapkan") {
                            planFood = SQLiteManager.shared.getPlanFoodByDateRange(startDate: startDate, endDate: endDate)
                            totalCalories = planFood.reduce(0) { $0 + ($1.calories ?? 0.0) }
                        }
                        .padding(.leading, 8)
                    }
                    .padding()
                    
                    Text("Total Kalori : \(totalCalories, specifier: "%.0f") kCal")
                        .font(.headline)
                        .padding()

                    if planFood.isEmpty {
                        VStack {
                            Image(systemName: "leaf.arrow.circlepath")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.green)
                                .padding(.bottom, 16)
                            
                            Text("Belum ada rencana makanan.")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 8)
                            
                            Text("Mulailah dengan menambahkan rencana makanan sehat untuk mencapai tujuan kalori harian Anda!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                        .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(planFood, id: \.idRecipe) { food in
                                    PlanFoodListItemView(foodRecipe: food) {
                                        SQLiteManager.shared.deletePlanFood(byId: food.idRecipe)
                                        loadFavorites()
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
            .navigationTitle("Plan Makan")
        }
    }
    
    private func loadFavorites() {
        planFood = SQLiteManager.shared.getPlanFoodByDateRange(startDate: startDate, endDate: endDate)
        totalCalories = planFood.reduce(0) { $0 + ($1.calories ?? 0.0) }
    }
}
