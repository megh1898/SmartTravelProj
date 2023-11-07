import SwiftUI
import Firebase

struct ContentView: View {
    
    private let splashDuration: Double = 2.0
    @State private var showSplashScreen = true // Use a flag to control the splash screen visibility
    @State private var isLoggedIn = false
    @ObservedObject var authViewModel: AuthViewModel
    @State var imageData = ImageData(imageURL: "", title: "", location: "", rating: "", filter: "", isFavourite: false)

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
//                DetailsScreen(imageData: imageData)
//                GiveFeedbackAndReview(rating: .constant(0.5))
            }
            .onAppear {
                
                FirebaseManager.shared.fetchImageData { imageData, error in
                    self.imageData = imageData?.first ?? ImageData(imageURL: "", title: "", location: "", rating: "", filter: "", isFavourite: false)
                }

                Timer.scheduledTimer(withTimeInterval: splashDuration, repeats: false) { _ in
                    withAnimation {
                        self.showSplashScreen = false // Hide the splash screen and show login screen
                    }
                }

            }
        }
    }
}

