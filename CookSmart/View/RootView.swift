//
//  RootView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct RootView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        TabView {
            HomeFoodView()
                .tabItem {
                    Label("Beranda", systemImage: "house.fill")
                }
            
            FavoritesFoodView()
                .tabItem {
                    Label("Favorit", systemImage: "heart.fill")
                }
            
            PlanFoodView()
                .tabItem{
                    Label("Plan Makan", systemImage: "calendar")
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
