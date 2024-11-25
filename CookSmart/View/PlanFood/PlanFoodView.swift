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
                    
                    Text("Total Kalori : \(totalCalories, specifier: "%.0f")")
                        .font(.headline)
                        .padding()
                    
                    if planFood.isEmpty {
                        Text("No Plan Food")
                            .font(.headline)
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(planFood, id: \.idRecipe) { food in
                                    NavigationLink(destination: DetailFood(
                                        viewModel: viewModel,
                                        idRecipe: food.idRecipe
                                    )) {
                                        PlanFoodListItemView(foodRecipe: food)
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
            .background(Color(hex: "#FFF6E9"))
        }
    }
    
    private func loadFavorites() {
        planFood = SQLiteManager.shared.getPlanFoodByDateRange(startDate: startDate, endDate: endDate)
        
        totalCalories = planFood.reduce(0) { $0 + ($1.calories ?? 0.0) }
    }
}
