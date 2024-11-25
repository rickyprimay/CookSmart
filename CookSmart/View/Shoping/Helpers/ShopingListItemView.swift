//
//  ShopingListItemView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 26/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShopingListItemView: View {
    let shoping: Shoping
    
    var body: some View {
        HStack(spacing: 15) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(shoping.name) | \(shoping.original)")
                    .font(.headline)
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
