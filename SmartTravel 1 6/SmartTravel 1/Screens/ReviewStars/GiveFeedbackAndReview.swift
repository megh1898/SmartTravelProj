//
//  GiveFeedbackAndReview.swift
//  SmartTravel 1
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI
import StarRating


struct GiveFeedbackAndReview: View {
    
    @State private var reviewText = ""
    @State private var isReviewSubmitted = false
    @State var customConfig = StarRatingConfiguration(numberOfStars: 5, minRating: 1)
    @State var rating: Double
    @Binding var imageData: ImageData
    @State private var showAlert = false
    @State var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Write a Review")
                        .font(.title3)
                        .padding()

                    TextEditor(text: $reviewText)
                        .frame(maxHeight: 100)
                        .padding()
                        .border(Color.gray, width: 1)
                        .cornerRadius(5)

                    // set the initialRating
                    // add a callback to do something with the new rating
                    StarRating(initialRating: 0.5, onRatingChanged: {
                        print($0)
                            rating = $0 // Update the @Binding variable with the new rating

                    }).frame(width: 300, height: 100)

                    
                    Button(action: {
                        // Submit the review (you can customize this part)
                        self.submitReview()
                    }) {
                        Text("Submit Review")
                            .font(.title3)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                }
                .padding()

                .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Message"),
                                message: Text("\(alertMessage)"),
                                dismissButton: .default(Text("OK"))
                            )
            }
            }
        }
    }

    func submitReview() {
        // Perform the review submission logic here
        // For demonstration purposes, we'll just set a flag to indicate submission
        isReviewSubmitted = true
        if validate() {
            FirebaseManager.shared.addReviewToFirestore(description: reviewText, rating: String(rating), location: imageData.location, title: imageData.title) { error in
                if error == nil {
                    print("Review Submitted")
                    reviewText = ""
                    alertMessage = "Review Submitted"
                    showAlert = true
                } else {
                    print("Error")
                    alertMessage = "Error"
                    showAlert = true
                }
            }
        } else {
            alertMessage = "Please Enter Review"
            showAlert    = true
        }
    }
    
    func validate() -> Bool {
        if reviewText.isEmpty {
            return false
        } else {
            return true
        }
    }
}


#Preview {
    GiveFeedbackAndReview(rating: 0.5, imageData: .constant(ImageData(imageURL: "", title: "", location: "", rating: "", filter: "", isFavourite: false)))
}
