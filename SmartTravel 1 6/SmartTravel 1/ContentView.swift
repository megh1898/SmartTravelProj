import SwiftUI
import Firebase

struct ContentView: View {
    
    private let splashDuration: Double = 2.0
    @State private var showSplashScreen = true // Use a flag to control the splash screen visibility
    @State private var isLoggedIn = false
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                if showSplashScreen {
                    SplashScreenView(isShowing: $showSplashScreen) // Show the SplashScreenView
                } else if isLoggedIn {
                    MainScreen(isLoggedIn: $isLoggedIn)
                } else {
                    SignInScreen(isLoggedIn: $isLoggedIn, authViewModel: authViewModel)
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: splashDuration, repeats: false) { _ in
                    withAnimation {
                        self.showSplashScreen = false // Hide the splash screen and show login screen
                    }
                }
                
                FirebaseManager.shared.fetchImageData { imagesData, error in
                    print(imagesData)
                }

            }
        }
    }
}

