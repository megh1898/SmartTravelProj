import SwiftUI
import CoreLocation

struct RatingOverlayView: View {
    var imageURL: String
    var rating: String

    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 350)
                        .clipped()
                case .failure:
                    Image("samples")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 230, height: 230)
                        .cornerRadius(5)
                        .clipped()
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .frame(width: 230, height: 230, alignment: .center)
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}

struct DetailsScreen: View {
    @State var imageData: ImageData
    @State private var showAlert = false
    @State var alertMessage = ""
    @State var text = ""
    @State private var showReviewSheet = false
    @State private var showReviews = false
    @State private var isFavorite = false
    @State private var showPayment = false
    @State private var alertTitle = "Message"

    var body: some View {
            ScrollView {
                VStack() {
                    RatingOverlayView(imageURL: imageData.imageURL, rating: imageData.rating)
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(imageData.title)
                                .font(Font.custom("Montserrat", size: 28))
                                .fontWeight(.heavy)
                            
                            Spacer()
                            
                            Button(action: {
                                didTappedFavourite()
                            }) {
                                
                                let image = isFavorite ? "heart.fill" : "heart"
                                
                                Image(systemName: image)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding()
                                    .background(.white)
                                    .foregroundColor(isFavorite ? Color.blue : .gray)
                                    .cornerRadius(10)
                            }
                        }

                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.blue)
                            
                            Text("\(imageData.location)")
                                .font(Font.custom("Montserrat", size: 18))
                                .foregroundColor(.gray)
                        }
                        
                        let location = CLLocation(latitude: imageData.latitude,
                                                  longitude: imageData.longitude)
                        
                        let userLocation = CLLocation(latitude: Double(AppUtility.shared.latitude ?? "") ?? 0,
                                                       longitude: Double(AppUtility.shared.longitude ?? "") ?? 0)
                        StatsView(location1: userLocation, location2: location, data: imageData)
                        
                        Text("Description:")
                            .font(Font.custom("Montserrat", size: 25))
                            .fontWeight(.bold)
                            .padding(.top, 10)

                        Text(imageData.description)
                            .font(Font.custom("Montserrat", size: 18))
                            .lineSpacing(5)

                        Spacer()
                        
//                        HStack {
//                            Button(action: didTappedOrder) {
//                                Text("Book A Trip")
//                                    .frame(width: 150)
//                                    .padding(8)
//                                    .buttonStyle(PrimaryButtonStyle())
//                            }
//                            .padding(.top)

//                            Spacer()

//                            Button(action: didTappedFavourite) {
//                                Text(text)
//                                    .frame(width: 150)
//                                    .padding(8)
//                                    .buttonStyle(PrimaryButtonStyle())
//                            }
//                            .padding(.top)
//                        }

//                        HStack {
//                            Button(action: { showReviewSheet = true }) {
//                                Text("Tap to Review")
//                                    .frame(width: 150)
//                                    .padding(8)
//                                    .buttonStyle(PrimaryButtonStyle())
//                            }
//
//                            Spacer()
//
//                            Button(action: { showReviews = true }) {
//                                Text("View Reviews")
//                                    .frame(width: 150)
//                                    .padding(8)
//                                    .buttonStyle(PrimaryButtonStyle())
//                            }
//                        }

//                        Spacer()
                        

                    }
                    .padding(12)
                }
                HStack {
                    Button(action: { showReviewSheet = true }) {
                        Text("Tap to Review")
                            .frame(width: 150)
                            .padding(8)
                            .buttonStyle(PrimaryButtonStyle())
                    }
                    
                    Spacer()
                    
                    Button(action: { showReviews = true }) {
                        Text("View Reviews")
                            .frame(width: 150)
                            .padding(8)
                            .buttonStyle(PrimaryButtonStyle())
                    }
                }
                Button(action: didTappedOrder) {
                    Text("Book Trip for $\(imageData.price)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        
                }
            }
            .edgesIgnoringSafeArea(.top)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }

            .background(
                NavigationLink(destination: GiveFeedbackAndReview(rating: 0.5, imageData: $imageData), isActive: $showReviewSheet) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(destination: ReviewListingView(imageData: $imageData), isActive: $showReviews) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(destination: PaymentView(imageData: $imageData), isActive: $showPayment) {
                    EmptyView()
                }
            )
            .onAppear {
                FirebaseManager.shared.getFavorites(userID: AppUtility.shared.userId!, targetFavoriteImageID: imageData.id) { data, err in
                    self.isFavorite = (data?.count ?? 0) > 0
                }
                
            }
            .toolbar(.visible, for: .navigationBar)
                    
    }

    func didTappedOrder() {
        if (AppUtility.shared.totalBalance ?? 0) >= imageData.price {
            showPayment.toggle()
        } else {
            showAlert.toggle()
            alertTitle = "insufficient Balance"
            alertMessage = "You have insufficient balance to book this trip"
        }
    }

    func didTappedFavourite() {
        if !isFavorite {
            FirebaseManager.shared.addFavorite(userID: AppUtility.shared.userId!, favoriteImageID: imageData.id) { err in
                if err == nil {
                    self.alertMessage = "Favourite List Updated"
                    isFavorite = true
                    showAlert = true
                }
                else {
                    self.alertMessage = "Error"
                    isFavorite = false
                }
            }

        } else {
            FirebaseManager.shared.deleteFavoriteByImageID(userID: AppUtility.shared.userId!, favoriteImageID: imageData.id) { err in
                if err == nil {
                    self.alertMessage = "Favourite List Updated"
                    isFavorite = false
                    showAlert = true
                } else {
                    self.alertMessage = "Error"
                }
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(red: 0.39, green: 0.56, blue: 0.89))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct BottomRoundedRectangle: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

struct StatsView: View {
    
    var location1: CLLocation? //user current location
    var location2: CLLocation? // place
    @State private var distance: Int?
    @State private var rating: String?
    var data: ImageData
    
    var body: some View {
        HStack {
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(Color(red: 0.39, green: 0.56, blue: 0.89)) // Adjust color as needed
                    
                    Image(systemName: "star")
                        .foregroundColor(.white)
                    
                }
            
                .frame(width: 30, height: 30)
                
                VStack(alignment: .leading) {
                    Text("Rating")
                        .font(.caption2)
                    Text(rating ?? "None")
                        .font(.caption2).bold()
                }
            }.padding(8)
            .background(.blue.opacity(0.4))
            .cornerRadius(8)
            
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(Color(red: 0.39, green: 0.56, blue: 0.89)) // Adjust color as needed
                    
                    Image(systemName: "arrow.triangle.swap")
                        .foregroundColor(.white)
                }
                .frame(width: 30, height: 30)
                
                
                VStack(alignment: .leading) {
                    Text("Distance")
                        .font(.caption2)
                    Text("\(distance ?? 0) km")
                        .font(.caption2).bold()
                }
            }.padding(8)
            .background(.blue.opacity(0.4))
            .cornerRadius(8)
        }
        .onAppear {
            calculateDistance()
            FirebaseManager.shared.fetchReviewsByTitleAndLocation(title: data.title, location: data.location) { reviews, error in
                if error == nil {
                    if let reviews = reviews?.map({ Double($0.rating) ?? 0 }) {
                        let averageRating = reviews.reduce(0.0, +) / Double(reviews.count)
                        let formattedRating = String(format: "%.2f", averageRating)
                        rating = "\(formattedRating) (\(reviews.count))"
                    }
                }
            }
        }
    }
    
    private func calculateDistance() {
        guard let location1 = location1, let location2 = location2 else {
            return
        }

        // Calculate distance in meters
        let distanceInMeters = location1.distance(from: location2)

        // Convert distance to kilometers
        let distanceInKilometers = Int(distanceInMeters / 1000.0)

        distance = distanceInKilometers
    }
}
