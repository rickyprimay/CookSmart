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
    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false
    
    @State private var startDate: Date = Date()
    
    @StateObject var authViewModel: AuthViewModel
    
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
                
                RecipeCardView(viewModel: viewModel, authViewModel: authViewModel, recipeId: idRecipe)
            }
            Toast(message: toastMessage, isVisible: $showToast)
                .padding(.bottom, 120)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await checkIfFavorite()
                await viewModel.getRecipeById(id: idRecipe)
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
    
    private func toggleFavoriteStatus() {
        if isFavorite {
            SQLiteManager.shared.removeFavorite(userId: authViewModel.currentUser.uid, id: idRecipe)
            toastMessage = "Resep telah dihapus dari favorit."
        } else {
            if let title = viewModel.foodRecipeDetail?.title, let image = viewModel.foodRecipeDetail?.image {
                SQLiteManager.shared.addFavorite(user_id: authViewModel.currentUser.uid, id: idRecipe, title: title, image: image)
                toastMessage = "Resep telah ditambahkan ke favorit."
            }
        }
        isFavorite.toggle()
        showToast = true
    }
    
    
    private func checkIfFavorite() async {
        let favoriteStatus = SQLiteManager.shared.isFavorite(userId: authViewModel.currentUser.uid, id: idRecipe)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isFavorite = favoriteStatus
        }
    }
    
    private func addToPlanFood(date: Date) {
        guard let title = viewModel.foodRecipeDetail?.title else {
            print("Missing recipe title.")
            return
        }
        guard let calorieNutrient = viewModel.nutrient.first(where: { $0.name == "Calories" }) else {
            print("Missing calorie data.")
            return
        }
        
        let calorie = calorieNutrient.amount
        
        
        let formattedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        SQLiteManager.shared.addPlanFood(user_id: authViewModel.currentUser.uid, id: idRecipe, title: title, image: viewModel.foodRecipeDetail?.image ?? "", calories: Float(calorie), date: formattedDate)
        toastMessage = "Resep telah dijadwalkan pada \(formattedDate)."
        showToast = true
    }
    
}




//#Preview {
//    DetailFood(viewModel: FoodRecipeViewModel(), idRecipe: 65432)
//}
