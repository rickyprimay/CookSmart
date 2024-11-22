//
//  AddFilterView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 21/11/24.
//

import SwiftUI

struct AddFilterView: View {
    @Binding var selectedFilters: [String]
    @State private var newFilter = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter a filter (e.g., Chicken, Vegan)", text: $newFilter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Filter") {
                    if !newFilter.isEmpty {
                        selectedFilters.append(newFilter)
                        newFilter = ""
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Add Filter")
            .navigationBarItems(leading: Button("Close") {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
}

