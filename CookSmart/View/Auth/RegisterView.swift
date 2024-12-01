//
//  RegisterView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 28/11/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var password: String = ""
    @State private var email: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var registrationSuccess: Bool = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    let lightGreyColor = Color(red: 239.0 / 255.0, green: 243.0 / 255.0, blue: 244.0 / 255.0, opacity: 1.0)
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Daftar")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                Text("Email")
                TextField("Masukan email...", text: $email)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5)
                    .autocapitalization(.none)
                
                Text("Password")
                SecureField("Masukan password...", text: $password)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5)
                
                Spacer()
                
                Button(action: register) {
                    Text("Register")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#FFF6E9"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
            }
            .padding()
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .disabled(isLoading)
        
        if isLoading {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ProgressView("Registering...")
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
    
    private func register() {
        Task {
            await authViewModel.signUp(email: email, password: password)
            if authViewModel.hasError {
                errorMessage = authViewModel.errorMessage
                showErrorAlert = true
            } else {
                registrationSuccess = true
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
