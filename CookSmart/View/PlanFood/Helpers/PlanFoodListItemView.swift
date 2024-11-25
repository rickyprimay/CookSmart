//
//  PlanFoodListItemView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 25/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlanFoodListItemView: View {
    let foodRecipe: PlanFood
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            WebImage(url: URL(string: foodRecipe.image ?? "https://img.spoonacular.com/recipes/662428-556x370.jpg"))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(foodRecipe.title ?? "")
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(String(format: "%.2f kcal", foodRecipe.calories ?? 0.0))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(formatDate(foodRecipe.date ?? ""))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private func formatDate(_ date: String) -> String {
        guard !date.isEmpty else { return "Unknown Date" }
        return date
    }
}
