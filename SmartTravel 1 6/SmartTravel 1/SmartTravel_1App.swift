import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase

@main
struct SmartTravel_1App: App {
    // Create an instance of AuthViewModel
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(authViewModel: authViewModel)
        }
    }
}

