//
//  SessionManager.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 28/11/24.
//

//import Foundation
//
//class SessionManager: ObservableObject {
//    @Published var isAuthenticated: Bool = false
//
//    init() {
//        checkAuthentication()
//    }
//
//    func checkAuthentication() {
//        if let token = UserDefaults.standard.string(forKey: "authToken") {
//            isAuthenticated = SQLiteManager.shared.validateToken(token: token)
//        } else {
//            isAuthenticated = false
//        }
//    }
//
//    func login(token: String) {
//        UserDefaults.standard.set(token, forKey: "authToken")
//        isAuthenticated = true
//    }
//
//    func logout() {
//        UserDefaults.standard.removeObject(forKey: "authToken")
//        isAuthenticated = false
//    }
//}
