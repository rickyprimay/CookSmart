//
//  AddFilterView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 21/11/24.
//

import SwiftUI

struct AddSheetView: View {
    @Binding var ingredients: [String]
    @State private var newIngredient: String = ""
    @Binding var vegetarian: Bool
    @Binding var vegan: Bool
    @Binding var gluten: Bool
    @Binding var keto: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(hex: "#FFF6E9")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Tambahkan Bahan")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Masukkan bahan-bahan yang kamu punya.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Ingredient Name", text: $newIngredient)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Toggle("Vegetarian", isOn: $vegetarian)
                    Toggle("Vegan", isOn: $vegan)
                    Toggle("Gluten", isOn: $gluten)
                    Toggle("Keto", isOn: $keto)
                }
                .padding(.horizontal)
                
                Button {
                    if !newIngredient.isEmpty {
                        ingredients.append(newIngredient)
                        newIngredient = ""
                    }
                    
                    if vegetarian && !ingredients.contains("Vegetarian") {
                        ingredients.append("Vegetarian")
                    }
                    if vegan && !ingredients.contains("Vegan") {
                        ingredients.append("Vegan")
                    }
                    if gluten && !ingredients.contains("Gluten-Free") {
                        ingredients.append("Gluten-Free")
                    }
                    if keto && !ingredients.contains("Keto") {
                        ingredients.append("Keto")
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save Filters")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#47663B"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
}
