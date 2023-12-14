import SwiftUI
import CoreLocation
import Firebase
import FirebaseFirestore
import CoreLocation
import Combine

struct HomeScreen: View {
    
    @State private var userLocation = "Select Location"
    @State private var name = ""
    @State private var selectedFilter: String = "Popular"
    @State var showLocationSheet = false
    @State var sampleImageData: [ImageData] = []
    
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack {
                HeaderView(showLocationSheet: $showLocationSheet, userLocation: $userLocation)
                
                IntroductionView(name: $name)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(sampleImageData, id: \.id) { item in
                            NavigationLink(destination: DetailsScreen(imageData: item)) {
                                ImageRectangle(imageURL: item.imageURL, text: "\(item.title), \(item.location)")
                            }
                        }
                    }
                }
                
                FilterButtons(selectedFilter: $selectedFilter)
                
                FilterSection(selectedFilter: $selectedFilter, filteredImages: $sampleImageData)
            }
            .onReceive(locationManager.$city) { newCity in
                userLocation = "\(newCity), \(locationManager.country)"
            }
            .onAppear {
                FirebaseManager.shared.fetchImageData { imagesData, error in
                    sampleImageData = imagesData ?? []
                }
                FirebaseManager.shared.getUserProfile(withId: AppUtility.shared.userId!) { data in
                    let username = data?.name ?? "Unknown"
                    AppUtility.shared.name = username
                    name = username
                }
            }
            .toolbar(.hidden, for: .tabBar)
            NavigationLink(destination: LocationsAnnotationView(locations: $sampleImageData, searchedLocation: CLLocation(latitude: Double(AppUtility.shared.latitude ?? "0.0") ?? 0, longitude: Double(AppUtility.shared.longitude ?? "0.0") ?? 0)),
                           isActive: $showLocationSheet) { EmptyView() }
        }
    }
}

struct HeaderView: View {
    @Binding var showLocationSheet : Bool
    @Binding var userLocation: String
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        HStack {
            
            Spacer()
            
            HStack {
                Image(systemName: "location.circle")
                    .foregroundColor(.blue)
                    
                Text("\(userLocation)")
                    .font(Font.custom("Montserrat", size: 18.11).weight(.light))
                    .foregroundColor(Color(red: 0.42, green: 0.47, blue: 0.54))
                    .onTapGesture {
                        showLocationSheet = true
                    }
            }
            
            Spacer()
            
            // User Account
            NavigationLink(destination: UserProfile()) {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(red: 0.13, green: 0.15, blue: 0.16).opacity(0.20))
                        .offset(x: -0, y: 0)
                    Circle()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.white)
                        .offset(x: 0, y: 0)
                    Circle()
                        .frame(width: 35, height: 35) // Reduce the size here
                        .foregroundColor(Color(red: 0.17, green: 0.21, blue: 0.26).opacity(0.55))
                        .offset(x: -0, y: 0)
                        .blur(radius: 5.17)
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 15, height: 15) // Adjust the size here
                        .foregroundColor(.white)
                        .offset(x: -0, y: 0)
                }
            }
        }
    }
}

struct IntroductionView: View {
    
    @Binding var name: String
    
    var body: some View {
        VStack(alignment: .leading) {
            // Introduction
            let name = "Hi " + name
            Text(name)
                .font(Font.custom("Montserrat", size: 16).weight(.light))
                .foregroundColor(Color(red: 0.22, green: 0.25, blue: 0.30))
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                
            
            Text("Where do you wanna go?")
                .font(Font.custom("Montserrat", size: 24).weight(.bold))
                .foregroundColor(Color(red: 0.04, green: 0.15, blue: 0.33))
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
        }
    }
}


struct FilterButtons: View {
    @Binding var selectedFilter: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                FilterButton(title: "Popular", icon: "flame.fill", selectedFilter: $selectedFilter)
                FilterButton(title: "Lake", icon: "drop.fill", selectedFilter: $selectedFilter)
                FilterButton(title: "Beach", icon: "beach.umbrella", selectedFilter: $selectedFilter)
                FilterButton(title: "Mountain", icon: "mountain.2.fill", selectedFilter: $selectedFilter)
            }
        }
    }
}

struct FilterButton: View {
    var title: String
    var icon: String
    @Binding var selectedFilter: String
    
    var body: some View {
        Button(action: {
            selectedFilter = title
        }) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .font(Font.custom("Montserrat", size: 18.11))
                    .lineSpacing(24)
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 10.35, leading: 7.76, bottom: 10.35, trailing: 12.94))
            .frame(width: 140, height: 50)
            .background(selectedFilter == title ? Color.blue : Color(red: 0.39, green: 0.56, blue: 0.89))
            .cornerRadius(6.47)
        }
    }
}

struct FilterSection: View {
    @Binding var selectedFilter: String
    @Binding var filteredImages: [ImageData]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            let images = filteredImages.filter { $0.filter.lowercased() == selectedFilter.lowercased() }
            HStack {
                ForEach(images, id: \.id) { item in
                    NavigationLink(destination: DetailsScreen(imageData: item)) {
                        FilterItem(imageURL: item.imageURL, title: item.title, location: item.location, rating: item.rating)
                    }
                }
            }
        }
    }
}

struct FilterItem: View {
    var imageURL: String
    var title: String
    var location: String
    var rating: String
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 281.99, height: 253.53)
                .background(.white)
                .cornerRadius(20.70)
                .overlay(
                    RoundedRectangle(cornerRadius: 20.70)
                        .inset(by: -0.65)
                        .stroke(Color(red: 0.93, green: 0.93, blue: 0.94), lineWidth: 0.65)
                )
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 258.71, height: 151.34)
                .background(
                    AsyncImage(url: URL(string: imageURL))
                )
                .cornerRadius(12.94)
                .offset(y: 10)
                .overlay(
                    Button(action: {
                        // Action to perform when the button is tapped
                        print("Button Tapped!")
                    }) {
//                        Image(systemName: "heart.fill")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .padding()
//                            .foregroundColor(.white)
                    }
                        .padding(.trailing, 6)
                        .padding(.top, 10),
                    alignment: .topTrailing
                )

            
            Text(title)
                .font(Font.custom("Montserrat", size: 18))
//                .lineSpacing(27.94)
                .foregroundColor(Color(red: 0.04, green: 0.15, blue: 0.33))
                .offset(x: -90, y: 170)
            
            Text(location)
                .font(Font.custom("Montserrat", size: 16).weight(.light))
//                .lineSpacing(20.96)
                .foregroundColor(Color(red: 0.42, green: 0.47, blue: 0.54))
                .offset(x: -80, y: 200)
            
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: 25, height: 25) // Adjust the size as needed
                .foregroundColor(Color(red: 0.39, green: 0.67, blue: 1))
                .offset(x: 110, y: 185)
        }
    }
}

struct UserProfileData: Identifiable, Decodable {
    var id: String? = UUID().uuidString
    var age: String?
    var bio: String?
    var email: String?
    var favorites: [String]?
    var interest: String?
    var location: String?
    var name: String?
    var profileImageURL: String?
    var balance: Int?
}

struct ImageData: Identifiable, Decodable {
    var id: String = UUID().uuidString
    var imageURL: String
    var title: String
    var location: String
    var rating: String
    var filter: String
    var isFavourite: Bool
    var description: String
    var latitude: Double
    var longitude: Double
    var price: Int
}

struct FavoritesList: Identifiable, Decodable {
    var id: String = UUID().uuidString
    var imageURL: String
    var title: String
    var location: String
    var rating: String
    var filter: String
    var isFavourite: Bool
    var description: String
}

struct ImageRectangle: View {
    var imageURL: String
    var text: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    // You can customize the placeholder image here
                    Image(systemName: "photo")
                        .resizable()
                        .background(.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .cornerRadius(16)
                        .padding(.trailing, 8)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .cornerRadius(16)
                        .padding(.trailing, 8)
                default:
                    // Handle other cases if needed
                    EmptyView()
                }
            }

            Text(text)
                .font(Font.custom("Montserrat", size: 16))
                .foregroundColor(.white)
                .bold()
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

