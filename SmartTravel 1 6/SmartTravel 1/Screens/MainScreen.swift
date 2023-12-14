import SwiftUI

struct MainScreen: View {
    @State var age = ""
    @Binding var isLoggedIn : Bool
    @StateObject private var authViewModel = AuthViewModel()
    var body: some View {
        NavigationView {
            VStack() {
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 350, height: 250)
                    .background(
                        Image("Logo.png")
                    )

                Text("make your travel easy")
                    .font(Font.custom("Roboto", size: 24).weight(.medium))
                    .foregroundColor(Color(red: 0.39, green: 0.56, blue: 0.89))
                    .padding(10)
                
                NavigationLink(destination: SignInScreen(isLoggedIn: $isLoggedIn,authViewModel: authViewModel)) {
                    Text("Sign in")
                        .font(Font.custom("Roboto", size: 14).weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 35)
                        .background(Color(red: 0.39, green: 0.67, blue: 1))
                        .cornerRadius(20)
                        .shadow(
                            color: Color(red: 0.27, green: 0.57, blue: 0.85, opacity: 0.25), radius: 7, y: 4
                        )
                }
                
                NavigationLink(destination: SignUpScreen( isLoggedIn: _isLoggedIn, age: $age, authViewModel: authViewModel)) {
                    Text("Sign up")
                        .font(Font.custom("Roboto", size: 14).weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 35)
                        .background(Color(red: 0.39, green: 0.56, blue: 0.90))
                        .cornerRadius(20)
                        .shadow(
                            color: Color(red: 0.27, green: 0.57, blue: 0.85, opacity: 0.25), radius: 7, y: 4
                        )
                }
                
            }
            .frame(width: 414, height: 736)
            .background(.white)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
            )
        }
    }
}
