//
//  Toast.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 27/11/24.
//

import SwiftUI

struct Toast: View {
    var message: String
    @Binding var isVisible: Bool

    var body: some View {
        if isVisible {
            Text(message)
                .font(.subheadline)
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .transition(.opacity)
                .onAppear {
                    print("Toast appeared")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            print("Toast hiding...")
                            isVisible = false
                        }
                    }
                }
        }
    }
}
