//
//  RootView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct RootView: View {
    
    @Environment(\.managedObjectContext) private var context
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
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
            
            ShopingFoodView()
                .tabItem {
                    Label("Belanja", systemImage: "bag.fill")
                }
        }
        .sheet(isPresented: $isFirstTime, content: {
            IntroScreenView()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    RootView()
}
