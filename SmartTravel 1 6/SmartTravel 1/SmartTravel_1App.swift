//
//  SmartTravel_1App.swift
//  SmartTravel 1
//
//  Created by MEGH SHAH on 2023-10-05.
//

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
            // Pass the authViewModel to your ContentView
            ContentView(authViewModel: authViewModel)
        }
    }
}

