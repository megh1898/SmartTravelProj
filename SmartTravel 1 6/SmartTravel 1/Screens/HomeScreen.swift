//
//  HomeScreen.swift
//  SmartTravel 1
//
//  Created by Sam 77 on 2023-10-08.
//

import SwiftUI
import CoreLocation
import Firebase
import FirebaseFirestore
import CoreLocation
import Combine

struct HomeScreen: View {
    @State private var userLocation = "Toronto,ON"
    @State private var selectedFilter: String = "Popular"
    @ObservedObject var locationManager = LocationManager()

    
    var body: some View {
        ScrollView {
            VStack {

                HeaderView(userLocation: $userLocation)
                IntroductionView()
                
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
                FilterSection(selectedFilter: $selectedFilter)
            }
            .onReceive(locationManager.$city) { newCity in
                userLocation = "\(newCity), \(locationManager.country)"
            }
            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
        }
    }

        struct HeaderView: View {
            
            @Binding var userLocation: String
            @State var presentSideMenu = false
            @State var selectedSideMenuTab = 0

            var body: some View {
                HStack {
                    //                Menu Button
//                    Button(action: {
//                        withAnimation {
//                            presentSideMenu.toggle()
//                                       }                    }) {
//                        Image("menu")
//                            .resizable()
//                            .frame(width: 35, height: 25)
//                            .padding(.vertical, 3.88)
//                    }   
//                                       .navigationTitle("Main Content")
                   

                    
                    Spacer()
                    
                    //                        Current Location
                    Text("\(userLocation)")
                                    .font(Font.custom("Montserrat", size: 18.11).weight(.light))
                                    .foregroundColor(Color(red: 0.42, green: 0.47, blue: 0.54))
                    
                    Spacer()
                    
                    
                    // User Account
                    NavigationLink(destination: UserProfile()) {
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(red: 0.13, green: 0.15, blue: 0.16).opacity(0.20))
                                .offset(x: -0, y: 0)
                                .blur(radius: 15.52)
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
            }
    
//struct SideMenu: View {
//    @Binding var isMenuVisible: Bool
//
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.5)
//                .edgesIgnoringSafeArea(.all)
//
//            HStack {
//                Text("Menu")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                Spacer()
//            }
//            .padding()
//            .background(Color.blue)
//            .frame(width: 200)
//
//        }
//        .onTapGesture {
//            withAnimation {
//                isMenuVisible.toggle()
//            }
//        }
//    }
//}

struct IntroductionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Introduction
            Text("Hi Krupa,")
                .font(Font.custom("Montserrat", size: 24).weight(.light))
                .foregroundColor(Color(red: 0.22, green: 0.25, blue: 0.30))
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                .padding(.leading, 20) // Add left padding

            Text("Where do you wanna go?")
                .font(Font.custom("Montserrat", size: 30    ).weight(.bold))
                .lineSpacing(30)
                .foregroundColor(Color(red: 0.04, green: 0.15, blue: 0.33))
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                .padding(.leading, 20) // Add left padding
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

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(sampleImageData.filter { $0.filter == selectedFilter }, id: \.id) { item in
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
            Text(title)
                .font(Font.custom("Montserrat", size: 20.70))
                .lineSpacing(27.94)
                .foregroundColor(Color(red: 0.04, green: 0.15, blue: 0.33))
                .offset(x: -80, y: 170)
            Text(location)
                .font(Font.custom("Montserrat", size: 15.52).weight(.light))
                .lineSpacing(20.96)
                .foregroundColor(Color(red: 0.42, green: 0.47, blue: 0.54))
                .offset(x: -90, y: 200)
            Text(rating)
                .font(Font.custom("Montserrat", size: 18.11).weight(.light))
                .lineSpacing(24.45)
                .foregroundColor(Color(red: 0.22, green: 0.25, blue: 0.30))
                .offset(x: 110, y: 185)
        }
    }
}
      
struct ImageData: Identifiable {
    var id = UUID()
    var imageURL: String
    var title: String
    var location: String
    var rating: String
    var filter: String
}

let sampleImageData: [ImageData] = [
    ImageData(imageURL: "https://images.pexels.com/photos/836941/pexels-photo-836941.jpeg?auto=compress&cs=tinysrgb&w=800322x301", title: "Henghe", location: "China", rating: "2.8", filter: "Popular"),
    ImageData(imageURL: "https://images.pexels.com/photos/93049/pexels-photo-93049.jpeg?auto=compress&cs=tinysrgb&w=800382x301", title: "Campo Belo", location: "Brazil", rating: "3.9", filter: "Beach"),
    ImageData(imageURL: "https://images.pexels.com/photos/803900/pexels-photo-803900.jpeg?auto=compress&cs=tinysrgb&w=800", title: "Buseresere", location: "Tanzania", rating: "3.8", filter: "Popular"),
    ImageData(imageURL: "https://images.pexels.com/photos/9253/sea-city-landscape-sky.jpg?auto=compress&cs=tinysrgb&w=800", title: "Tío Pujio", location: "Argentina", rating: "4.6", filter: "Mountain"),
    ImageData(imageURL: "https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?cs=srgb&dl=pexels-tom%C3%A1%C5%A1-mal%C3%ADk-3408353.jpg&fm=jpg", title: "Kyoto", location: "Japan", rating: "5.0", filter: "Beach"),
    ImageData(imageURL: "https://img.freepik.com/free-photo/asian-woman-wearing-japanese-traditional-kimono-yasaka-pagoda-sannen-zaka-street-kyoto-japan_335224-40.jpg?size=626&ext=jpg&ga=GA1.1.386372595.1697587200&semt=sph", title: "Osaka", location: "Japan", rating: "4.9", filter: "Lake"),
    ImageData(imageURL: "https://img.freepik.com/premium-photo/fuji-mountain-lake-morning-with-autumn-seasons-leaves-japan_763111-13442.jpg?size=626&ext=jpg&ga=GA1.1.1413502914.1697328000&semt=ais", title: "Fuji", location: "Japan", rating: "4.9", filter: "Beach"),
    ImageData(imageURL: "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/26/97/39/7f/caption.jpg?w=1200&h=-1&s=1&cx=1920&cy=1080&chk=v1_f31158e4bb953d28a308", title: "Tokyo", location: "Japan", rating: "5.0", filter: "Lake")
]

    struct ImageRectangle: View {
        var imageURL: String
        var text: String
        
        var body: some View {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 380, height: 350)
                    .background(
                        AsyncImage(url: URL(string: imageURL))
                    )
                    .cornerRadius(42)
                    .padding(20)
            
                Text(text)
                    .font(Font.custom("Montserrat", size: 23.28))
                    .lineSpacing(31.43)
                    .foregroundColor(.white)
                    .padding(40)
                    
            }
        }
    }
    
    struct HomeScreen_Previews: PreviewProvider {
        static var previews: some View {
            HomeScreen()
        }
    }

