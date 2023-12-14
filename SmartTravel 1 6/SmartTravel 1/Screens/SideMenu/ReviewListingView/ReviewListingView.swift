import SwiftUI
import StarRating

struct ReviewListingView: View {
   
    @State var reviewsData = [ReviewData]()
    @Binding var imageData: ImageData
    
    var body: some View {
        ScrollView {
            ForEach(reviewsData, id: \.id) { item in
                ReviewCellView(imageData: $imageData, reviewsData: $reviewsData, reviewData: item)
            }
            .padding()
        }
        .onAppear {
            FirebaseManager.shared.fetchReviewsByTitleAndLocation(title: imageData.title,
                                                                  location: imageData.location) { reviews, error in
                self.reviewsData = reviews ?? []
                self.reviewsData = self.reviewsData.sorted { $0.date > $1.date }
            }
        }
        .navigationTitle("Reviews and Ratings")
        .navigationBarTitleDisplayMode(.large)
    }
}


struct ReviewCellView: View {
    @State private var name: String = ""
    @State private var showAlert = false
    @Binding var imageData: ImageData
    @Binding var reviewsData: [ReviewData]
    var reviewData = ReviewData(id: "", location: "", rating: "", description: "", title: "", reviewerId: "", reviewId: "", username: "", date: Date())
    @State private var showReviewSheet = false
    
    var body: some View {
        VStack {
        
            HStack {
                Text(name)
                    .font(.system(size: 22,weight: .semibold))
                Spacer()
                Text(formatDateToString(reviewData.date))
                    .font(.system(size: 16,weight: .semibold))
                    .foregroundColor(Color.gray)
            }
            
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
            
            if reviewData.reviewerId == AppUtility.shared.userId {
                HStack {
                    Spacer()
                    Button {
                        FirebaseManager.shared.deleteReviewFromFirestore(documentId: reviewData.id) { err in
                            if err == nil {
                                self.reviewsData.removeAll { $0.id == reviewData.id }
                                self.showAlert.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .font(.title)
                            .tint(.red)
                    }
                    Spacer().frame(width: 20)
                    
                    Button {
                        showReviewSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .font(.title)
                    }

                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.04))
        .cornerRadius(10)
        .background(
            NavigationLink(destination: GiveFeedbackAndReview(rating: 0.5, 
                                                              imageData: $imageData,
                                                              isEditReview: true,
                                                              reviewData: reviewData),
                           isActive: $showReviewSheet) {
                EmptyView()
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Review Deleted Successfully"),
                message: Text(""),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            FirebaseManager.shared.getUserProfile(withId: reviewData.reviewerId) { user in
                name = user?.name ?? ""
            }
        }
    }
    func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: date)
    }
}
