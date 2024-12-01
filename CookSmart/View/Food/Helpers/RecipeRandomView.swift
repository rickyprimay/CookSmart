//
//  RecipeRandomView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeCardViews: View {
    let foodRecipe: Recipe
    @ObservedObject var viewModel: FoodRecipeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WebImage(url: URL(string: foodRecipe.image ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .cornerRadius(10)
                .clipped()

            Text(foodRecipe.title ?? "No Title")
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: 150, alignment: .leading)

            HStack {
                Text("\(foodRecipe.readyInMinutes) minutes")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                statusView
            }
        }
        .frame(width: 150)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }

    private var statusView: some View {
        Group {
            if foodRecipe.vegan {
                statusLabel(text: "Vegan", color: .green)
            } else if foodRecipe.vegetarian {
                statusLabel(text: "Vegetarian", color: .orange)
            } else if foodRecipe.glutenFree {
                statusLabel(text: "Gluten Free", color: .purple)
            } else if foodRecipe.dairyFree {
                statusLabel(text: "Dairy Free", color: .pink)
            }
        }
    }

    private func statusLabel(text: String, color: Color) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(5)
    }
}

struct RecipeListItemView: View {
    let foodRecipe: SearchRecipe
    
    var body: some View {
        HStack(spacing: 15) {
            WebImage(url: URL(string: foodRecipe.image))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(foodRecipe.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct GenerateRecipeListItemView: View {
    let foodRecipe: GenerateRecipe
    
    var body: some View {
        HStack(spacing: 15) {
            WebImage(url: URL(string: foodRecipe.image))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(foodRecipe.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
