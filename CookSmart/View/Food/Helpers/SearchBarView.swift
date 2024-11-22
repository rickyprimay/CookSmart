//
//  SearchBarView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    
    var placeholder: String = "Search"
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(10)
                .background(Color(hex: "#EED3B1" ).opacity(0.6))
                .cornerRadius(10)
                .foregroundColor(.white)
                .font(.system(size: 16))
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.trailing, 10)
        }
        .padding(.horizontal, 10)
        .background(Color(hex: "#EED3B1" ))
        .cornerRadius(15)
    }
}


