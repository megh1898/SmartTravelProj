//
//  DetailsScreen.swift
//  SmartTravel 1
//
//  Created by Sam 77 on 2023-10-15.
//

import SwiftUI

struct DetailsScreen: View {
    var imageData: ImageData

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
                    
                    
                    
                    Spacer()
                }
                .padding(8)
            }
        }
//        .navigationBarTitle("Details", displayMode: .inline)
    }
}

struct DetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailsScreen(imageData: sampleImageData[0])
    }
}

