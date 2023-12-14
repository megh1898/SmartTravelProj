import SwiftUI

struct MainTabbedView: View {
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @State private var isLoggedIn = true
    @ObservedObject var authViewModel: AuthViewModel
    
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack{
                    TabView(selection: $selectedSideMenuTab) {
                        HomeVieww(presentSideMenu: $presentSideMenu)
                            .tag(0)
                        FavoriteListingView(presentSideMenu: $presentSideMenu)
                            .tag(1)
                        NotificationListingView(presentSideMenu: $presentSideMenu)
                            .tag(2)
                        OrderListingView(presentSideMenu: $presentSideMenu)
                            .tag(3)
                        LogoutView(authViewModel: authViewModel)
                            .onAppear {
                                authViewModel.signOut()
                            }
                            .tag(4)
                       
                    }
                    SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
                    
                }
            }
        }
    }
}

struct LogoutView: View {
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        Text("Loggin out")
    }
}
