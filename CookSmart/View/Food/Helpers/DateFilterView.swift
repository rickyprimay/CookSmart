//
//  DateFilterView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 26/11/24.
//

import SwiftUI

struct DateFilterView: View {
    @Binding var dateAdded: Date
    var onSubmit: (Date) -> ()
    var onClose: () -> ()
    
    private var currentDate: Date {
        return Date()
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Pilih Tanggal Makan")
                .font(.headline)
                .foregroundColor(.primary)
            
            DatePicker("", selection: $dateAdded, in: currentDate..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
                .accentColor(.green)
            
            HStack(spacing: 15) {
                Button("Cancel") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                Button("Jadwalkan") {
                    onSubmit(dateAdded)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.green)
            }
            .padding(.top, 10)
        }
        .padding(15)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}
