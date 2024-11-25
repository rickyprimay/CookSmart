//
//  RecipeCardView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct RecipeCardView: View {
    
    @State private var selectedTab: String = "ingred"
    
    @StateObject var viewModel = FoodRecipeViewModel()
    var recipeId: Int
    
    func removeHTMLTags(from html: String) -> String {
        if let data = html.data(using: .utf8) {
            do {
                let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                return attributedString.string
            } catch {
                print("Error parsing HTML: \(error)")
            }
        }
        return html
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(.white)
                    .frame(height: (UIScreen.main.bounds.height * 2) / 3)
                    .shadow(color: .black.opacity(0.9), radius: 3)
                    .cornerRadius(10, corners: [.topRight, .topLeft])
                
                VStack {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 60, height: 5)
                        .cornerRadius(10)
                    
                    HStack {
                        Text(viewModel.foodRecipeDetail?.title ?? "")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Image(systemName: "clock")
                        Text("\(viewModel.foodRecipeDetail?.readyInMinutes ?? 0) min")
                    }
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
                    .padding(.horizontal)
                    
                    Text(removeHTMLTags(from: viewModel.foodRecipeDetail?.summary ?? "No description available."))
                        .padding(.top, 8)
                    
                    Grid(alignment: .topLeading, horizontalSpacing: 60) {
                        GridRow {
                            ForEach(viewModel.nutrient, id: \.name) { nutrient in
                                if nutrient.name == "Protein" {
                                    NutrientDetailCardView(emoji: "🍗", nutrientContent: "\(nutrient.amount)g protein")
                                } else if nutrient.name == "Fat" {
                                    NutrientDetailCardView(emoji: "🧈", nutrientContent: "\(nutrient.amount)g lemak")
                                }
                            }
                        }
                        GridRow {
                            ForEach(viewModel.nutrient, id: \.name) { nutrient in
                                if nutrient.name == "Calories" {
                                    NutrientDetailCardView(emoji: "🍫", nutrientContent: "\(nutrient.amount) kCal")
                                } else if nutrient.name == "Sugar" {
                                    NutrientDetailCardView(emoji: "🍡", nutrientContent: "\(nutrient.amount)g gula")
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Button {
                            self.selectedTab = "ingred"
                        } label : {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedTab == "ingred" ? .black : .gray.opacity(0.3))
                                .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: 50)
                                .overlay {
                                    Text("Bahan")
                                        .foregroundStyle(selectedTab == "ingred" ? .white : .black.opacity(0.5))
                                        .fontWeight(.bold)
                                }
                        }
                        
                        Button {
                            self.selectedTab = "instruct"
                        } label : {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedTab == "instruct" ? .black : .clear)
                                .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: 50)
                                .overlay {
                                    Text("Instruksi")
                                        .foregroundStyle(selectedTab == "instruct" ? .white : .black.opacity(0.5))
                                        .fontWeight(.bold)
                                }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.secondary.opacity(0.2))
                        }
                    }
                    
                    if selectedTab == "ingred" {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(viewModel.foodRecipeDetail?.extendedIngredients ?? [], id: \.name) { ingredient in
                                    HStack(alignment: .top) {
                                        Text("✅")
                                        Text(ingredient.original)
                                            .fontWeight(.medium)
                                            .font(.subheadline)
                                        Spacer()
                                        
                                        Button {
                                            SQLiteManager.shared.addShoppingItem(
                                                id: ingredient.id,
                                                name: ingredient.name,
                                                original: ingredient.original
                                            )
                                        } label: {
                                            Image(systemName: "plus")
                                                .font(.title)
                                                .fontWeight(.regular)
                                                .foregroundStyle(.green)
                                                .padding(8)
                                                .background(Color(hex: "#F1F1F1"), in: RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.white)
                                            .shadow(color: .black.opacity(0.3), radius: 3)
                                    }
                                }

                            }
                        }
                        .padding(.top, 20)
                        .frame(height: 225)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(viewModel.foodRecipeDetail?.analyzedInstructions.flatMap { $0.steps } ?? [], id: \.number) { step in
                                    HStack(alignment: .top) {
                                        Text("\(step.number). ")
                                            .bold()
                                        
                                        Text(step.step)
                                            .fontWeight(.medium)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.white)
                                            .shadow(color: .black.opacity(0.3), radius: 3)
                                    }
                                }
                            }
                        }
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity)
                        .frame(height: 225)
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
                .padding([.leading, .trailing, .bottom], 40)
                .edgesIgnoringSafeArea(.bottom)
            }
            .padding(.top, 20)
        }
        .padding(.top, 100)
        .task {
            await viewModel.getRecipeById(id: recipeId)
        }
    }
}
