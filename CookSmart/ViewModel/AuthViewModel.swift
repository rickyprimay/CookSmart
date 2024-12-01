//
//  AuthViewModel.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 01/12/24.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    @Published private var _currentUser : User? = nil
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var isLoggedIn = false
    
    private var handler = Auth.auth().addStateDidChangeListener{_,_ in }
    
    var currentUser: User {
        return _currentUser ?? User(uid: "", email: "")
    }
    
    init(){
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self._currentUser = User(uid: user.uid, email: user.email!)
                self.isLoggedIn = true
                print("User logged in: \(user.email ?? "No Email")")
            } else {
                self._currentUser = nil
                self.isLoggedIn = false
                print("User not logged in.")
            }
        }
    }
    
    func signIn(email: String, password: String) async {
        hasError = false
        do{
            try await Auth.auth().signIn(withEmail: email, password: password)
        }catch{
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func signOut() async {
        hasError = false
        do{
            try Auth.auth().signOut()
            
        }catch{
            hasError = true
            errorMessage = error.localizedDescription
        }
        
    }
    
    func signUp(email: String, password: String) async {
        hasError = false
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    deinit{
        Auth.auth().removeStateDidChangeListener(handler)
    }
}
