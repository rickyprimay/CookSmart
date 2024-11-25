//
//  IntroScreenView.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 26/11/24.
//

import SwiftUI

struct IntroScreenView: View {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        VStack{
            Text("Selamat Datang di Aplikasi CookSmart")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            VStack(alignment: .leading, spacing: 25) {
                PointView(
                    symbol: "fork.knife",
                    title: "Cari Resep sesuai barang yang kalian punya",
                    subTitle: "Temukan resep yang kamu inginkan dengan mudah."
                )
                PointView(
                    symbol: "calendar",
                    title: "Atur jadwal makan harian",
                    subTitle: "Buat resep yang kamu inginkan dengan mudah."
                )
                PointView(
                    symbol: "heart.fill",
                    title: "Simpan Resep Favorit",
                    subTitle: "Temukan resep favoritmu dengan mudah."
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 25)
            
            Spacer(minLength: 10)
            
            Button{
                isFirstTime.toggle()
            } label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#47663B"), in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            }
        }
        .padding(15)
    }
    
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Color(hex: "#47663B"))
                .frame(width:45)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.gray)
            })
        }
    }
    
}


#Preview {
    IntroScreenView()
}
