//
//  SideMenu.swift
//  SideMenuView
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI

struct SideMenu: View {
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(
                        Color.clear
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}


enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case favorite
    case notification
    case order
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .favorite:
            return "Favorite"
        case .notification:
            return "Notification"
        case .order:
            return "Order"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "favorite"
        case .favorite:
            return "favorite"
        case .notification:
            return "favorite"
        case .order:
            return "favorite"
        }
    }
}
