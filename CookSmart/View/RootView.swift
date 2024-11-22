//
//  RootView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            HomeFoodView()
                .tabItem {
                    Label("Beranda", systemImage: "house.fill")
                }
            
            Text("Favorites")
                .tabItem {
                    Label("Favorit", systemImage: "heart.fill")
                }
            Text("Belanja Produk")
                .tabItem {
                    Label("Belanja", systemImage: "bag.fill")
                }
        }
    }
}

#Preview {
    RootView()
}
