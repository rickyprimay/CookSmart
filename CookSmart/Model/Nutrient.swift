//
//  Nutrient.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct Nutrient: Decodable {
    let name: String
    let amount: Double
}

struct NutrientResult: Decodable {
    let nutrients: [Nutrient]
}
