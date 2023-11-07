//
//  MainTabbedView.swift
//  SmartTravel 1
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI

struct MainTabbedView: View {
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        ZStack{
            
            TabView(selection: $selectedSideMenuTab) {
                HomeVieww(presentSideMenu: $presentSideMenu)
                    .tag(0)
                FavoriteListingView(presentSideMenu: $presentSideMenu)
                    .tag(1)
                OrderListingView(presentSideMenu: $presentSideMenu)
                    .tag(2)
                NotificationListingView(presentSideMenu: $presentSideMenu)
                    .tag(3)
            }
            
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
    }
}
