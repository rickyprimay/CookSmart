//
//  NutrientDetailView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct NutrientDetailCardView: View {
    var emoji: String
    var nutrientContent: String
    
    var body: some View {
        HStack(spacing: 2) {
            Text(emoji)
                .font(.title)
                .padding(7)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.yellow.opacity(0.7))
                )
            Text(nutrientContent)
                .foregroundStyle(.black.opacity(0.7))
                .bold()
                .font(.headline)
        }
        .fontWeight(.medium)
        .foregroundStyle(.black.opacity(0.9))
    }
}
