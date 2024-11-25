//
//  RecipeFavoriteListItemView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 25/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeFavoriteListItemView: View {
    let foodRecipe: FavoriteFood
    
    var body: some View {
        HStack(spacing: 15) {
            WebImage(url: URL(string: foodRecipe.image ?? "https://img.spoonacular.com/recipes/662428-556x370.jpg"))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(foodRecipe.title ?? "lonte")
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
