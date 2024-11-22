//
// ContentView.swift
// CookSmart
//
// Created by Ricky Primayuda Putra on 20/11/24.
//

import SwiftUI

struct DetailFood: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: FoodRecipeViewModel
    
    @State var idRecipe: Int

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
                        
                    } label: {
                        Image(systemName: "heart")
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
                }
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
            Task{
                await viewModel.getRecipeById(id: idRecipe)
            }
        }
    }
}
