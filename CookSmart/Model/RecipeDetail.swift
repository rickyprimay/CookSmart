//
//  RecipeDetail.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 21/11/24.
//

import SwiftUI

struct RecipeDetail: Codable {
    let id: Int
    let title: String
    let image: String
    let summary: String
    let readyInMinutes: Int
    let servings: Int
    let extendedIngredients: [ExtendedIngredient]
    let analyzedInstructions: [AnalyzedInstruction]
}

struct ExtendedIngredient: Codable, Identifiable {
    let id: Int
    let name: String
    let original: String
}

struct AnalyzedInstruction: Codable {
    let steps: [Step] 
}

struct Step: Codable {
    let number: Int
    let step: String
}
