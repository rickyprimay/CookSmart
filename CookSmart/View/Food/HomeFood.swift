//
//  HomeFoodView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct HomeFoodView: View {
    
    @StateObject var viewModel = FoodRecipeViewModel()
    @State private var searchText = ""
    @State private var showAddSheet = false
    @State private var ingredients: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(hex: "#FFF6E9")
                    .ignoresSafeArea()
                ScrollView{
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("What’s cooking tonight?")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text("Find recipes based on your ingredients!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image("me")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                        }
                        .padding(.horizontal)
                        
                        SearchBarView(text: $searchText)
                            .padding(.horizontal, 10)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack{
                                Image(systemName: "wand.and.stars")
                                    .foregroundStyle(Color(hex: "#47663B"))
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .bold()
                                    .frame(width: 50, height: 50)
                                    .background(.white.opacity(0.6))
                                    .cornerRadius(10)
                                    .padding(.trailing, 5)
                                
                                Text("We'll conjure a recipe from your ingredients")
                                    .foregroundStyle(.black.opacity(0.6))
                                    .font(.title3)
                                    .fontWeight(.medium)
                                
                                
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading){
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading) {
                                    ForEach(ingredients, id: \.self) { ingredient in
                                        HStack(alignment: .top, spacing: 0) {
                                            Text(ingredient)
                                                .font(.subheadline)
                                                .padding(5)
                                            
                                            Button {
                                                // Hapus bahan dari daftar
                                                if let index = ingredients.firstIndex(of: ingredient) {
                                                    ingredients.remove(at: index)
                                                }
                                            } label: {
                                                Image(systemName: "xmark")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.red)
                                                    .padding([.trailing, .top, .bottom], 5)
                                            }
                                        }
                                        .background(Color(hex: "#EED3B1").opacity(0.5))
                                        .cornerRadius(10)
                                    }
                                    HStack(alignment: .top, spacing: 0) {
                                        
                                        
                                        Button {
                                            showAddSheet = true
                                        } label: {
                                            Text("Add")
                                                .font(.subheadline)
                                                .foregroundStyle(.black.opacity(0.6))
                                                .padding(5)
                                        }
                                        
                                        
                                    }
                                    .background(Color(hex: "#EED3B1").opacity(0.3))
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .clipped()
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            Button{
                                //
                            } label: {
                                HStack {
                                    Image(systemName: "wand.and.stars")
                                        .font(.title)
                                        .foregroundColor(.white)
                                    Text("Generate Recipe")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#47663B"))
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color(hex: "#EED3B1" ))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    
                    
                    
                    VStack(alignment: .leading, spacing: 20) {
                        if searchText.isEmpty {
                            HStack {
                                Text("Recommended for You")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Text("See All")
                                        .font(.subheadline)
                                        .padding(.horizontal)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.foodRecipe) { foodRecipe in
                                        NavigationLink(destination: DetailFood(viewModel: viewModel, idRecipe: foodRecipe.id)) {
                                            RecipeCardViews(foodRecipe: foodRecipe, viewModel: viewModel)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            // Search Results Section
                            Text("Search Results")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if viewModel.foodRecipe.isEmpty {
                                Text("No results found.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .padding()
                            } else {
                                VStack(spacing: 15) {
                                    ForEach(viewModel.foodRecipe) { foodRecipe in
                                        NavigationLink(destination: DetailFood(viewModel: viewModel, idRecipe: foodRecipe.id)) {
                                            RecipeListItemView(foodRecipe: foodRecipe)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                
            }
            .background(Color(hex: "#FFF6E9"))
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddSheet) {
                AddSheetView(ingredients: $ingredients)
            }
        }
        .onAppear {
            Task {
                await viewModel.getRandomRecipe()
            }
        }
    }
}

struct AddSheetView: View {
    @Binding var ingredients: [String]
    @State private var newIngredient: String = ""
    @State private var vegetarian = false
    @State private var vegan = false
    @State private var glutenFree = false
    @State private var dairyFree = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(hex: "#FFF6E9")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Add Ingredients")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Enter the ingredients you want to add.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Ingredient Name", text: $newIngredient)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 15) {
                    Toggle("Vegetarian", isOn: $vegetarian)
                    Toggle("Vegan", isOn: $vegan)
                    Toggle("Gluten Free", isOn: $glutenFree)
                    Toggle("Dairy Free", isOn: $dairyFree)
                }
                .padding(.horizontal)
                
                Button {
                    if !newIngredient.isEmpty {
                        ingredients.append(newIngredient)
                        newIngredient = ""
                    }
                    
                    if vegetarian {
                        ingredients.append("Vegetarian")
                    }
                    if vegan {
                        ingredients.append("Vegan")
                    }
                    if glutenFree {
                        ingredients.append("Gluten Free")
                    }
                    if dairyFree {
                        ingredients.append("Dairy Free")
                    }

                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#47663B"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    HomeFoodView()
}
