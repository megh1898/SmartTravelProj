//
//  ReviewListingView.swift
//  SmartTravel 1
//
//  Created by Invotyx Mac on 07/11/2023.
//

import SwiftUI
import StarRating

struct ReviewListingView: View {
   
    @State var reviewsData = [ReviewData]()
    @Binding var imageData: ImageData

    var body: some View {
        ScrollView {
            Text("Reviews and Ratings")
                .padding()
            ForEach(reviewsData, id: \.id) { item in
                ReviewCellView(reviewData: item)
            }
        }
        .onAppear {
            FirebaseManager.shared.fetchReviewsByTitleAndLocation(title: imageData.title, location: imageData.location) { reviews, error in
                self.reviewsData = reviews ?? []
            }
        }
    }
}

#Preview {
    ReviewListingView(imageData: .constant(ImageData(imageURL: "", title: "", location: "", rating: "", filter: "", isFavourite: false)))
}


struct ReviewCellView: View {
    
    var reviewData = ReviewData(id: "", location: "", rating: "", description: "", title: "")

    var body: some View {
        VStack {
            HStack {
                Text("Title:")
                Spacer()
                Text(reviewData.title)
                    .font(.system(size: 18,weight: .semibold))
            }
            HStack {
                Text("Location:")
                Spacer()
                Text(reviewData.location)
                    .font(.system(size: 18,weight: .semibold))
            }
            HStack {
                Text("Description:")
                Spacer()
                Text(reviewData.description)
                    .font(.system(size: 18,weight: .semibold))
            }
            HStack {
                Text("Rating:")
                Spacer()
                Text(reviewData.rating)
                    .font(.system(size: 18,weight: .semibold))
            }
        }
        .padding()
        .background(Color.black.opacity(0.04))
        .cornerRadius(10)
    }

}
