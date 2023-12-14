import SwiftUI

struct PaymentView: View {
    @State private var cardHolderName = ""
    @State private var cardNumber = ""
    @State private var expMonth = ""
    @State private var expYear = ""
    @State private var cvc = ""
    @State private var dateString = ""
    
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible = false

    
    @State private var isCardHolderNameValid = false
    @State private var isCardNumberValid = false
    @State private var isExpMonthValid = false
    @State private var isExpYearValid = false
    @State private var isCvcValid = false
    
    @State private var showAlert = false
    @State private var isProcessing = false
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""
    
    @Binding var imageData: ImageData
    
    var body: some View {
        VStack {
            ZStack {
                
                Form {
                    Section(header: Text("Card Information")) {
                        TextField("Cardholder Name", text: $cardHolderName)
                            .onChange(of: cardHolderName) { newValue in
                                isCardHolderNameValid = !newValue.isEmpty
                            }
                            .foregroundColor(isCardHolderNameValid ? .primary : .red)
                        
                        TextField("Card Number", text: $cardNumber)
                            .keyboardType(.numberPad)
                            .onChange(of: cardNumber) { newValue in
                                isCardNumberValid = isValidCardNumber(newValue)
                            }
                            .foregroundColor(isCardNumberValid ? .primary : .red)
                        
                        HStack {
                            TextField("Exp Month (MM)", text: $expMonth)
                                .keyboardType(.numberPad)
                                .onChange(of: expMonth) { newValue in
                                    isExpMonthValid = isValidExpDate(newValue)
                                }
                                .foregroundColor(isExpMonthValid ? .primary : .red)
                            
                            Spacer(minLength: 20)
                            
                            TextField("Exp Year (YY)", text: $expYear )
                                
                                .keyboardType(.numberPad)
                                .onChange(of: expYear) { newValue in
                                    isExpYearValid = isValidExpDate(newValue)
                                }
                                .foregroundColor(isExpYearValid ? .primary : .red)
                        }
                        
                        TextField("CVC", text: $cvc)
                            .keyboardType(.numberPad)
                            .onChange(of: cvc) { newValue in
                                isCvcValid = isValidCVC(newValue)
                            }
                            .foregroundColor(isCvcValid ? .primary : .red)
                        
                        TextField("Booking Date", text: $dateString)
//                            .keyboardType(.numberPad)
//                            .foregroundColor(isCvcValid ? .primary : .red)
                            .onTapGesture {
                                isDatePickerVisible.toggle()
                            }
                    }
                    
                    Section {
                        Button(action: {
                            // Check if all fields are valid before processing payment
                            if isCardHolderNameValid && isCardNumberValid && isExpYearValid && isExpYearValid && isCvcValid {
                                
                                isProcessing.toggle()
                                
                                FirebaseManager.shared.addOrder(filter: imageData.filter, location: imageData.location, rating: imageData.rating, title: imageData.title, date: dateString, price: imageData.price) { error in
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2)  {
                                        
                                        self.isProcessing = false
                                        
                                        if error == nil {
                                            let newBalance = (AppUtility.shared.totalBalance ?? 0) - imageData.price
                                            FirebaseManager.shared.updateBalance(newBalance: newBalance) { isSuccess, err in
                                                if isSuccess {
                                                    AppUtility.shared.totalBalance = newBalance
                                                    print("Payment Deducted")
                                                } else {
                                                    print(err?.localizedDescription ?? "")
                                                }
                                            }
                                            
                                            self.showSuccessAlert.toggle()
                                            self.alertMessage = "Successfully Order Placed"
                                            FirebaseManager.shared.addNotification(userID: AppUtility.shared.userId!,
                                                                                   notification: "You successfully booked an order in \(imageData.title), \(imageData.location)"){ error in
                                                if error == nil {
                                                    print("Notification added")
                                                }
                                            }
                                            
                                        } else {
                                            self.alertMessage = "An error occured while transaction"
                                            showAlert = true
                                            print("Error")
                                        }
                                    }
                                }
                                
                            } else {
                                // Show an alert for invalid input
                                alertMessage = "Please fill in all the required fields correctly."
                                showAlert.toggle()
                            }
                        }) {
                            Text("Pay Now")
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    
                    if isDatePickerVisible {
                        DatePicker("age", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                            .padding()
                        Button("Done") {
                            isDatePickerVisible = false
                            dateString = getFormattedDate()
                        }
                        .padding()
                        .foregroundColor(.blue)
                    }
                }
                .padding()
                
                if isProcessing {
                    ProgressView()
                        .frame(width: 150, height: 150)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(8.0)
                }
                
                
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.large)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Trasaction Successful"),
                message: Text("Payment is deducted and trip has been booked."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: selectedDate)
    }
    
    private func isValidCardNumber(_ cardNumber: String) -> Bool {
        // Implement your card number validation logic here
        // For simplicity, let's check if it's a numeric string with at least 16 digits
        return cardNumber.isNumeric && cardNumber.count == 16
    }
    
    private func isValidExpDate(_ expDate: String) -> Bool {
        // Implement your expiration date validation logic here
        // For simplicity, let's check if it's a numeric string with a length of 4
        return expDate.isNumeric && expDate.count == 2
    }
    
    private func isValidCVC(_ cvc: String) -> Bool {
        // Implement your CVC validation logic here
        // For simplicity, let's check if it's a numeric string with a length of 3
        return cvc.isNumeric && cvc.count == 3
    }
}

extension String {
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

