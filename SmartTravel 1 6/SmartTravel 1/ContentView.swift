import SwiftUI
import Firebase

struct ContentView: View {
    @State var presentSideMenu = false
    private let splashDuration: Double = 0.1
    @State private var showSplashScreen = true // Use a flag to control the splash screen visibility
    @State private var isLoggedIn = false
    @ObservedObject var authViewModel: AuthViewModel
    @State var imageData = ImageData(imageURL: "", title: "", location: "", rating: "", filter: "", isFavourite: false, description: "", latitude: 0.0, longitude: 0.0, price: 0)

    var body: some View {
        NavigationStack {
            ZStack {
                if showSplashScreen {
                    SplashScreenView(isShowing: $showSplashScreen)
                } else if isLoggedIn {
//                    MainScreen(isLoggedIn: $isLoggedIn)
                    HomeScreen()
                } else {
                    SignInScreen(isLoggedIn: $isLoggedIn, authViewModel: authViewModel)
                }
            }
            .onAppear {
                
                FirebaseManager.shared.fetchImageData { imageData, error in
                    self.imageData = imageData?.first ?? ImageData(imageURL: "", title: "", location: "", rating: "", filter: "", isFavourite: false, description: "", latitude: 0.0, longitude: 0.0, price: 0)
                }

                Timer.scheduledTimer(withTimeInterval: splashDuration, repeats: false) { _ in
                    withAnimation {
                        self.showSplashScreen = false
                    }
                }
            }
        }
    }
}
