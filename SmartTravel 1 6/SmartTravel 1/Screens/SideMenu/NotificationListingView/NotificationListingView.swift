//
//  NotificationListingView.swift
//  SideMenuView
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI

struct NotificationListingView: View {
    
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        VStack{
            HStack {
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            Text("Notification Listing View")
            NotificationCellView(notificationDescription: "Description")
        }
        .padding(.horizontal, 24)
    }
    
}

#Preview {
    NotificationListingView(presentSideMenu: .constant(true))
}

struct NotificationCellView: View {
    
    var notificationDescription: String
        
    var body: some View {
            Text("Description")
                .multilineTextAlignment(.leading) // Horizontal alignment
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black.opacity(0.04))
                .cornerRadius(10)
        
        
    }
}
