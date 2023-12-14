import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpScreen: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var bio = ""
//    @State private var age = ""
    @Binding var age: String
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible = false
    @State private var isProcessing = false
    
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            VStack {
                HStack {
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
                
                CustomTextField(title: "Name", text: $name, contentType: .name)
                CustomTextField(title: "Email", text: $email, contentType: .emailAddress)

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
                CustomTextField(title: "Age", text: $age, contentType: .telephoneNumber)
                    .onTapGesture {
                        isDatePickerVisible.toggle()
                    }
                CustomTextField(title: "Bio", text: $bio, contentType: .emailAddress)

                Spacer()

                Button(action: {
                    signUp()
                }) {
                    Text("Create Account")
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
                }
                if isDatePickerVisible {
                    DatePicker("age", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .padding()
                    Button("Done") {
                        isDatePickerVisible = false
                        age = getFormattedDate()
                    }
                    .padding()
                    .foregroundColor(.blue)
                }
                
            }
        }
        .toolbar(.hidden, for: .bottomBar)
        .padding([.leading, .trailing], 16)
        .onAppear {
            if authViewModel.isAuthenticated {
                isLoggedIn = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    private func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: selectedDate)
    }

    private func signUp() {
        
        if name.isEmpty {
            showAlert(title: "Empty Name", message: "Please enter your name.")
            return
        }
        
        if !email.isValidEmail() {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        if password.isEmpty || password.count < 6 {
            showAlert(title: "Empty Password", message: "Please enter atleast 6 characters password.")
            return
        }
        
        if age.isEmpty {
            showAlert(title: "Empty Age", message: "Please enter your age.")
            return
        }
        
        if bio.isEmpty {
            showAlert(title: "Empty Bio", message: "Please enter your bio.")
            return
        }
        
//        
        isProcessing = true
        authViewModel.email = email
        authViewModel.password = password
        authViewModel.name = name
        authViewModel.bio = bio
        authViewModel.age = age
        authViewModel.balance = 1000
        authViewModel.signUp { isSuccess in
            
            if isSuccess ?? false {
//                isLoggedIn = true
                
                showAlert = true
                alertTitle = "Success"
                alertMessage = "Account Created Successfully"
                
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            authViewModel.isAuthenticated = true
//        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var contentType: UITextContentType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(
                Font.custom("Roboto", size: 14)
                .weight(.bold)
                )
                .foregroundColor(.black)
            
            TextField(title, text: $text)
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
                .textContentType(contentType)
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
   
    static var previews: some View {
        @State var age = ""
        SignUpScreen(isLoggedIn: .constant(false), age: $age, authViewModel: AuthViewModel())
    }
    
}
extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

}
