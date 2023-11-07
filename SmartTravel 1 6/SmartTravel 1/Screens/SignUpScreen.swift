import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpScreen: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Image("Logo.png")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom, 20)
            
            Text("Sign Up")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.bottom, 10)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.bottom, 20)

            Button(action: {
                signUp()
            }) {
                Text("Create Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
        .onAppear {
            if authViewModel.isAuthenticated {
                isLoggedIn = true
            }
        }
    }

    private func signUp() {
        authViewModel.email = email
        authViewModel.password = password
        authViewModel.signUp()
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(isLoggedIn: .constant(false), authViewModel: AuthViewModel())
    }
}

