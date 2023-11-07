//
//  DetailsScreen.swift
//  SmartTravel 1
//
//  Created by Sam 77 on 2023-10-15.
//

import SwiftUI

struct DetailsScreen: View {
    
    @State var imageData: ImageData
    @State private var showAlert = false
    @State var alertMessage = ""
    @State var text = ""
    @State private var showReviewSheet = false // Add a state variable to control the sheet presentation
    @State private var showReviews = false // Add a state variable to control the sheet presentation

    
    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .bottom) {
                    AsyncImage(url: URL(string: imageData.imageURL)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                        } else if phase.error != nil {
                            // Handle error
                            Image("placeholder_image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 230, height: 230)
                                .cornerRadius(5)
                                .clipped()
                        } else {
                            // Show placeholder while loading
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        }
                    }

                    Text("Rating: \(imageData.rating)")
                        .font(Font.custom("Montserrat", size: 20))
                        .padding(10)
                        .background(Color(red: 0.39, green: 0.56, blue: 0.89))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(imageData.title)
                        .font(Font.custom("Montserrat", size: 25))                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text("Location: \(imageData.location)")
                        .font(Font.custom("Montserrat", size: 18))                        .foregroundColor(.gray)
                    
                    Text("Description:")
                        .font(Font.custom("Montserrat", size: 25))                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac varius nunc, eget posuere urna. Praesent sit amet metus id lorem condimentum viverra ac vel odio.")
                        .font(Font.custom("Montserrat", size: 18))                        .lineSpacing(5)
                    
                    HStack {
                        Button {
                            didTappedOrder()
                        } label: {
                            Text("Place Order")
                                .padding(4)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            
                        }
                        .padding(.top)
                        
                        
                        Button {
                            didTappedFavourite()
                        } label: {
                            
                            Text(text)
                                .padding(4)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            
                        }
                        .padding(.top)
                    }
                    HStack {
                        Button {
                            print("Cancelled")
                            showReviewSheet = true // Set the state variable to true to present the sheet
                            
                        } label: {
                            Text("Tap to Review")
                                .padding(4)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        Button {
                            showReviews = true
                        } label: {
                            Text("Check Reviews")
                                .padding(4)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)

                        }

                    }
                    
                    Spacer()
                }
                .padding(8)
            }
//            .sheet(isPresented: $showReviewSheet) {
//                GiveFeedbackAndReview(rating: 0.5, imageData: $imageData) // Present the GiveFeedbackAndReview view
//                }


            .background(
                NavigationLink(
                    destination: GiveFeedbackAndReview(rating: 0.5, imageData: $imageData),
                    isActive: $showReviewSheet,
                    label: {
                        EmptyView()
                    }
                )
            )
            
            .background(
                NavigationLink(
                    destination: ReviewListingView(imageData: $imageData),
                    isActive: $showReviews,
                    label: {
                        EmptyView()
                    }
                )
            )


            .onAppear {
                if imageData.isFavourite {
                    text = "Remove Favourite"
                } else {
                    text = "Add to Favourite"
                }
            }
            
            .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Message"),
                            message: Text("\(alertMessage)"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            

        }
//        .navigationBarTitle("Details", displayMode: .inline)
    }
    
    func didTappedOrder() {
        FirebaseManager.shared.addOrder(filter: imageData.filter, location: imageData.location, rating: imageData.rating, title: imageData.title) { error in
            if error == nil {
                self.alertMessage = "Successfully Order Placed"
                showAlert = true
                print("Ordered")
                FirebaseManager.shared.addNotification(description: "You successfully booked an order in \(imageData.title), \(imageData.location)") { error in
                    if error == nil {
                        print("Error")
                    } else {
                        print("Notification added")
                    }
                }
            } else {
                self.alertMessage = "Error"
                showAlert = true
                print("Error")
            }
        }
    }
    
    func didTappedFavourite() {
        FirebaseManager.shared.toggleImageOrderFavourite(imageData: imageData) { error in
            if error == nil {
                self.alertMessage = "Favourite List Updated"
                if text == "Remove Favourite" {
                    text = "Add to Favourite"
                } else {
                    text = "Remove Favourite"
                }
                showAlert = true
                print("Updated")
            } else {
                self.alertMessage = "Error"
                showAlert = true
                print("Error")
            }
        }
    }
}

struct DetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailsScreen(imageData: sampleImageData[0])
    }
}

