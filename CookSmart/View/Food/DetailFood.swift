//
//  DetailFood.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct DetailFood: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: FoodRecipeViewModel
    @State var idRecipe: Int
    @State private var isFavorite: Bool = false
    @State private var showCalendarSheet = false
    
    @State private var startDate: Date = Date()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                AsyncImage(url: URL(string: "\(viewModel.foodRecipeDetail?.image ?? "")")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                } placeholder: {
                    ProgressView()
                        .foregroundStyle(.gray)
                }
                Spacer()
            }
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                            .font(.title2)
                            .fontWeight(.regular)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 30)
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                        showCalendarSheet.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.green)
                            .font(.title2)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 30)
                            )
                    }
                    
                    Button {
                        toggleFavoriteStatus()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(.black)
                            .font(.title2)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 30)
                            )
                    }
                }
                .padding(.horizontal, 30)
                .padding()
                .padding()
                .padding(.top)
                .padding(.bottom)
                Spacer()
                
                RecipeCardView(viewModel: viewModel, recipeId: idRecipe)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await checkIfFavorite()
                await viewModel.getRecipeById(id: idRecipe)
                print(SQLiteManager.shared.isFavorite(id: idRecipe))
            }
        }
        .sheet(isPresented: $showCalendarSheet) {
            DateFilterView(dateAdded: $startDate, onSubmit: { start in
                showCalendarSheet.toggle()
                addToPlanFood(date: start)
            }, onClose: {
                showCalendarSheet.toggle()
            })
            .cornerRadius(20)
            .padding()
        }
    }
    
    private func checkIfFavorite() async {
        let favoriteStatus = SQLiteManager.shared.isFavorite(id: idRecipe)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isFavorite = favoriteStatus
        }
    }
    
    private func toggleFavoriteStatus() {
        if isFavorite {
            SQLiteManager.shared.removeFavorite(id: idRecipe)
            print("remove")
        } else {
            if let title = viewModel.foodRecipeDetail?.title, let image = viewModel.foodRecipeDetail?.image {
                print("Adding favorite with title: \(title) and image: \(image)")
                SQLiteManager.shared.addFavorite(id: idRecipe, title: title, image: image)
                print("add")
            } else {
                print("Title or Image is missing. Title: \(viewModel.foodRecipeDetail?.title ?? "nil"), Image: \(viewModel.foodRecipeDetail?.image ?? "nil")")
            }
        }
        
        isFavorite.toggle()
    }
    
    private func addToPlanFood(date: Date) {
        guard let title = viewModel.foodRecipeDetail?.title,
              let image = viewModel.foodRecipeDetail?.image else {
            print("Missing recipe title or image.")
            return
        }
        
        guard let calorieNutrient = viewModel.nutrient.first(where: { $0.name == "Calories" }) else {
            print("Missing calorie data.")
            return
        }
        
        let calorie = calorieNutrient.amount
        
        let formattedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        
        SQLiteManager.shared.addPlanFood(id: idRecipe, title: title, image: image, calories: Float(calorie), date: formattedDate)
    }
}




//#Preview {
//    DetailFood(viewModel: FoodRecipeViewModel(), idRecipe: 65432)
//}
