//
//  LoginView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 28/11/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showRegisterSheet: Bool = false
    @State private var isLoading: Bool = false
    
    let lightGreyColor = Color(red: 239.0 / 255.0, green: 243.0 / 255.0, blue: 244.0 / 255.0, opacity: 1.0)
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hi")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.black)
                        Text("Kembali Lagi!")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Image("bitmap")
                        .resizable()
                        .frame(width: 120, height: 80)
                        .padding()
                }
                .frame(height: 180)
                .padding(30)
                .background(Color(hex: "#FFF6E9"))
                .clipShape(CustomShape(corner: .bottomRight, radius: 50))
                .edgesIgnoringSafeArea(.top)
                
                VStack(alignment: .leading) {
                    Text("E-mail")
                    TextField("E-mail...", text: $email)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5)
                        .autocapitalization(.none)
                    
                    Text("Password")
                    SecureField("Password...", text: $password)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5)
                    
                    
                    HStack {
                        Spacer()
                        Button(action: login) {
                            Text("Sign In")
                                .bold()
                                .font(.callout)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(hex: "#FFF6E9"))
                    .cornerRadius(15)
                    
                    HStack {
                        Text("Belum punya akun?")
                            .bold()
                            .font(.callout)
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: { showRegisterSheet = true }) {
                            Text("Sign Up")
                                .bold()
                                .font(.callout)
                                .foregroundColor(.black)
                        }
                    }.padding()
                }
                .padding(30)
                
                Spacer()
            }
            .disabled(isLoading)
            
            if isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView("Logging in...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .sheet(isPresented: $showRegisterSheet) {
            RegisterView()
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            RootView()
        }
    }
    
    private func login() {
        isLoading = true
        Task {
            await viewModel.signIn(email: email, password: password)
            isLoading = false
        }
    }
}
