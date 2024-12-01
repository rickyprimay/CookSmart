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
    @Binding var minCalories: Double
    @Binding var maxCalories: Double
    @State private var errorMessage: String?

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
                
                TextField("Nama Bahan", text: $newIngredient)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                Button {
                    if ingredients.contains(newIngredient) {
                        errorMessage = "Bahan '\(newIngredient)' sudah ada."
                    } else {
                        ingredients.append(newIngredient)
                        newIngredient = ""
                        errorMessage = nil
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Tambahkan Bahan")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#47663B"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Toggle("Vegetarian", isOn: $vegetarian)
                    Toggle("Vegan", isOn: $vegan)
                    Toggle("Gluten", isOn: $gluten)
                    Toggle("Keto", isOn: $keto)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Kalori").font(.headline)
                        .opacity(ingredients.isEmpty ? 0.5 : 1.0)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Min:")
                                .font(.subheadline)
                            
                            TextField("Min Kalori", value: $minCalories, format: .number)
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Max:")
                                .font(.subheadline)
                            
                            TextField("Max Kalori", value: $maxCalories, format: .number)
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 20)

                }
                .padding(.horizontal)
                
                Button {
                    if !newIngredient.isEmpty {
                        ingredients.append(newIngredient)
                        newIngredient = ""
                    }
                    
                    if minCalories > maxCalories {
                        errorMessage = "Min Kalori harus lebih kecil dari Max Kalori"
                        return
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
                    Text("Simpan Filter")
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
