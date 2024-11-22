//
//  Extensions+Color.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var hexSanitized = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        
        if hexSanitized.count == 6 {
            let scanner = Scanner(string: hexSanitized)
            var rgb: UInt64 = 0
            if scanner.scanHexInt64(&rgb) {
                let red = Double((rgb & 0xFF0000) >> 16) / 255.0
                let green = Double((rgb & 0x00FF00) >> 8) / 255.0
                let blue = Double(rgb & 0x0000FF) / 255.0
                self.init(red: red, green: green, blue: blue)
                return
            }
        }
        
        self.init(white: 1.0)
    }
}
