import SwiftUI

struct HomeFoodView: View {
    
    @StateObject var viewModel = FoodRecipeViewModel()
    @State private var searchText = ""
    @State private var showAddSheet = false
    @State private var ingredients: [String] = []
    
    @State private var vegetarian = false
    @State private var vegan = false
    @State private var gluten = false
    @State private var keto = false
    
    @State private var hasFetchedRandomRecipe = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#FFF6E9")
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#47663B")))
                        .scaleEffect(1.5)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            headerSection
                            
                            SearchBarView(text: $searchText)
                                .padding(.horizontal, 10)
                                .onChange(of: searchText) { newValue in
                                    Task {
                                        await viewModel.searchRecipe(query: newValue)
                                    }
                                }
                            
                            ingredientsSection
                            
                            Button(action: generateRecipe) {
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
                            
                            recipesSection
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
                    }
                }
                
                
            }
            .background(Color(hex: "#FFF6E9"))
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddSheet) {
                AddSheetView(
                    ingredients: $ingredients,
                    vegetarian: $vegetarian,
                    vegan: $vegan,
                    gluten: $gluten,
                    keto: $keto
                )
            }
            .onAppear {
                if !hasFetchedRandomRecipe {
                    Task {
                        await viewModel.getRandomRecipe()
                        hasFetchedRandomRecipe = true
                    }
                }
            }
        }
    }
    
    
    private var headerSection: some View {
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
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "wand.and.stars")
                    .foregroundColor(Color(hex: "#47663B"))
                    .font(.title)
                    .bold()
                    .frame(width: 50, height: 50)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .padding(.trailing, 5)
                
                Text("We'll conjure a recipe from your ingredients")
                    .foregroundColor(.black.opacity(0.6))
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading) {
                ForEach(ingredients, id: \.self) { ingredient in
                    ingredientChip(for: ingredient)
                }
                addButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var recipesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if searchText.isEmpty {
                recommendedRecipesSection
            } else {
                searchResultsSection
            }
        }
        .padding(.vertical)
    }
    
    private var recommendedRecipesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Recommended for You")
                    .font(.headline)
                    .padding(.horizontal)
                
                Spacer()
                
                Button("See All") {}
                    .font(.subheadline)
                    .padding(.horizontal)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.foodRecipe) { foodRecipe in
                        NavigationLink(destination: DetailFood(
                            viewModel: viewModel,
                            idRecipe: foodRecipe.id
                        )) {
                            RecipeCardViews(foodRecipe: foodRecipe, viewModel: viewModel)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Search Results")
                .font(.headline)
                .padding(.horizontal)
            
            if viewModel.searchRecipeResult.isEmpty {
                Text("No results found.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(viewModel.searchRecipeResult) { recipe in
                    NavigationLink(destination: DetailFood(
                        viewModel: viewModel,
                        idRecipe: recipe.id
                    )) {
                        RecipeListItemView(foodRecipe: recipe)
                    }
                }
            }
        }
    }
    
    private func ingredientChip(for ingredient: String) -> some View {
        HStack {
            Text(ingredient)
                .font(.subheadline)
                .padding(5)
            Button {
                if let index = ingredients.firstIndex(of: ingredient) {
                    ingredients.remove(at: index)
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding([.trailing, .top, .bottom], 5)
            }
        }
        .background(Color(hex: "#EED3B1").opacity(0.5))
        .cornerRadius(10)
    }
    
    private var addButton: some View {
        Button("Add") {
            showAddSheet = true
        }
        .font(.subheadline)
        .foregroundColor(.black.opacity(0.6))
        .padding(5)
        .background(Color(hex: "#EED3B1").opacity(0.3))
        .cornerRadius(10)
    }
    
    private func generateRecipe() {
        let filters: [String: Bool] = [
            "vegetarian": vegetarian,
            "vegan": vegan,
            "gluten": gluten,
            "keto": keto
        ]
        
        Task {
            await viewModel.generateRecipe(query: searchText, filters: filters)
        }
    }
}
