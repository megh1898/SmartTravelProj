//
//  SplashScreenView.swift
//  SmartTravel 1
//
//  Created by MEGH SHAH on 2023-10-19.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.15, blue: 0.33)
                .ignoresSafeArea()

            VStack {
                Image("")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)

                Text("SmartTravel")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Text("make your travel easy")
                    .font(Font.custom("Roboto", size: 24).weight(.medium))
                    .foregroundColor(.white)
                    .padding(10)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowing = false
            }
        }
    }
}
