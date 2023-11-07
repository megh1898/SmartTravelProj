//
//  AuthViewModel.swift
//  SmartTravel 1
//
//  Created by MEGH SHAH on 2023-10-05.
//
import SwiftUI

import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var error: Error?

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            print(authResult)
            if let error = error {
                self.error = error
            } else {
                self.isAuthenticated = true
            }
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            print(authResult?.user.displayName)
            print(authResult?.user.phoneNumber)
            

            if let error = error {
                self.error = error
            } else {
                self.isAuthenticated = true
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func updateProfile(displayName: String, photoURL: URL?) {
           let user = Auth.auth().currentUser

           let changeRequest = user?.createProfileChangeRequest()
           changeRequest?.displayName = displayName
           changeRequest?.photoURL = photoURL

           changeRequest?.commitChanges { [weak self] error in
               guard let self = self else { return }
               if let error = error {
                   self.error = error
               }
           }
       }

       func deleteAccount() {
           let user = Auth.auth().currentUser

           user?.delete { [weak self] error in
               guard let self = self else { return }
               if let error = error {
                   self.error = error
               } else {
                   self.isAuthenticated = false
               }
           }
       }
   }



