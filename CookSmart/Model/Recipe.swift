//
//  Recipe.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct Recipe: Identifiable, Decodable {
    let id: Int
    let title: String?
    let readyInMinutes: Int
    let image: String?
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let summary: String?
    
}
