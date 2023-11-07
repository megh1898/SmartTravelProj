//
//  FavoriteListingView.swift
//  SideMenuView
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI


struct FavoriteListingView: View {
    
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            
            Spacer()
            Text("Favourite Listing View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
}
