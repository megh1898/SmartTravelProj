import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name = ""
    @Published var bio = ""
    @Published var age = ""
    @Published var balance = 0
    @Published var isAuthenticated: Bool = false
    @Published var error: Error?
    
    func signUp(completion: @escaping (Bool?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.error = error
            } else {
                if let user = authResult?.user {
                    createUserProfileInFirestore(user: user) { _ in
                        completion(true)
                    }
                }
            }
        }
    }
    
    func signIn(completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.error = error
                completion(false)
            } else {
                completion(true)
                self.isAuthenticated = true
                getUserRecord(email)
            }
        }
    }
    
    func createUserProfileInFirestore(user: User, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("userProfile")
        
        usersCollection.document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                print("User profile already exists in Firestore.")
            } else {
                // User profile document doesn't exist, create a new one
                let userData: [String: Any] = [
                    "email": user.email ?? "",
                    "id": user.uid,
                    "name": self.name,
                    "bio": self.bio,
                    "age": self.age,
                    "balance": self.balance
                ]
                
                usersCollection.document(user.uid).setData(userData) { error in
                    if let error = error {
                        print("Error creating user profile: \(error.localizedDescription)")
                    } else {
                        print("User profile created successfully in Firestore.")
                        DispatchQueue.main.async {
                            self.isAuthenticated = true
                            AppUtility.shared.email = self.email
                            AppUtility.shared.userId = user.uid
                            AppUtility.shared.name = self.name
                            completion(true)
                        }
                    }
                }
            }
        }
    }

    
    func getUserRecord(_ email: String) {
        let user = Auth.auth().currentUser
        
        if let user = user {
            
            AppUtility.shared.email = email
            
            let uid = user.uid
            AppUtility.shared.userId = uid
            
            let _ = user.photoURL
            
            var multiFactorString = "MultiFactor: "
            
            for info in user.multiFactor.enrolledFactors {
                
                multiFactorString += info.displayName ?? "[DispayName]"
                
                multiFactorString += " "
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
