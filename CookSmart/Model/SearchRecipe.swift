//
//  SearchRecipe.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 23/11/24.
//

import SwiftUI

struct SearchRecipe: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String
}

struct SearchRecipeResult : Decodable {
    let results: [SearchRecipe]
}
