import SwiftUI

struct SignInScreen: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var signInError: String? = nil
    @ObservedObject var authViewModel: AuthViewModel
    @State private var isSignUpActive = false
    @State private var isSigningIn = false
    @State var age = ""
    @State var isShowingPopup1 = false
    
    var body: some View {
        if authViewModel.isAuthenticated {
            MainTabbedView(authViewModel: authViewModel)
        } else {
            NavigationStack {
                VStack {
                    HStack() {
                        Text("Smart Travel")
                          .font(Font.custom("Acme", size: 48))
                          .foregroundColor(Color(red: 0.06, green: 0.24, blue: 0.47))
                        .padding(.bottom, 20)
                        Spacer()
                    }
                    
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 166, height: 140)
                      .background(
                        Image("Logo.png")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 166, height: 140)
                          .clipped()
                          .opacity(0.8)
                      )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(
                            Font.custom("Roboto", size: 14)
                            .weight(.bold)
                            )
                            .foregroundColor(.black)
                        
                        TextField("Input your email", text: $email)
                            .font(
                            Font.custom("Roboto", size: 14)
                            .weight(.light)
                            )
                            .padding()
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.35))
                            .foregroundColor(.clear)
                            .frame(width: 350, height: 35)
                            .background(.white.opacity(0.56))
                            .cornerRadius(20)
                            .overlay(
                              RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.39, green: 0.67, blue: 1), lineWidth: 1)
                            )
                                                
                        
                        
                            .textContentType(.emailAddress)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Password")
                            .font(
                            Font.custom("Roboto", size: 14)
                            .weight(.bold)
                            )
                            .foregroundColor(.black)
                        
                        SecureField("******", text: $password)
                            .font(
                            Font.custom("Roboto", size: 14)
                            .weight(.light)
                            )
                            .padding()
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.35))
                            .foregroundColor(.clear)
                            .frame(width: 350, height: 35)
                            .background(.white.opacity(0.56))
                            .cornerRadius(20)
                            .overlay(
                              RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.39, green: 0.67, blue: 1), lineWidth: 1)
                            )
                            .textContentType(.password)
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        signIn()
                    }) {
                        Text("Sign In")
                            .font(
                            Font.custom("Roboto", size: 14)
                            .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 125, height: 35)
                            .background(Color(red: 0.39, green: 0.67, blue: 1))
                            .cornerRadius(20)
                            .shadow(color: Color(red: 0.27, green: 0.57, blue: 0.85).opacity(0.25), radius: 3.5, x: 0, y: 4)
//                            .padding(.horizontal, 20)
                    }
                    .overlay(
                        isSigningIn ? ProgressView() : nil
                    )

//                    if let error = authViewModel.error {
//                        Text(error.localizedDescription)
//                            .foregroundColor(.red)
//                            .padding()
//                    }

                    Spacer()
                        .frame(height: 20)

                    NavigationLink(
                        destination: SignUpScreen(isLoggedIn: $isLoggedIn, age: $age, authViewModel: authViewModel),
                        isActive: $isSignUpActive,
                        label: {
                            Text("Don't have an account? Sign up here")
                                .font(
                                Font.custom("Roboto", size: 12)
                                .weight(.light)
                                )
                                .foregroundColor(.black)
                        }
                    )
                }
                .toolbar(.hidden, for: .bottomBar)
                .padding(20)
                .navigationBarHidden(true)
                .onAppear {
                    isSigningIn = false
                }
                .alert(isPresented: $isShowingPopup1) {
                    Alert(
                        title: Text("Invalid Credential"),
                        message: Text("Please try again"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    private func signIn() {
        isSigningIn = true
        authViewModel.email = email
        authViewModel.password = password
        authViewModel.signIn { isSuccess in
            if !isSuccess {
                isShowingPopup1 = true
            }
            isSigningIn = false
        }
    }
}
