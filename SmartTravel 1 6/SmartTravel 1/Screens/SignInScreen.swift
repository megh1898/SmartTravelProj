import SwiftUI
import FirebaseAuth

struct SignInScreen: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var signInError: String? = nil
    @ObservedObject var authViewModel: AuthViewModel
    @State private var isSignUpActive = false // Track sign-up screen activation

    var body: some View {
        if authViewModel.isAuthenticated {
            HomeScreen()
        } else {
            NavigationView {
                VStack {
                    Spacer()
                    Image("Logo.png")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)
                        .padding(.bottom, 40)

                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, 20)

                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.password)
                            .padding(.horizontal, 20)
                    }

                    Button(action: {
                        signIn()
                    }) {
                        Text("Sign In")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }

                    if let error = authViewModel.error {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Spacer()

                    NavigationLink(
                        destination: SignUpScreen(isLoggedIn: $isLoggedIn, authViewModel: authViewModel),
                        isActive: $isSignUpActive,
                        label: {
                            Text("Don't have an account? Sign up here")
                                .foregroundColor(.blue)
                                .font(.headline)
                        }
                    )
                }
                .padding(.vertical, 40)
                .background(
                    Image("BackgroundImage") // Use your background image here
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                )
                .navigationBarHidden(true)
            }
            .onAppear {
                // Add a background image to the entire screen for a more immersive look
            }
        }
    }

    private func signIn() {
        authViewModel.email = email
        authViewModel.password = password
        authViewModel.signIn()
    }
}

