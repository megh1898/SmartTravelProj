import SwiftUI
import MapKit
import Foundation
import CoreLocation


struct LocationsList: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct LocationsAnnotationView: View {
    @Binding var locations: [ImageData]
    @State private var showingSheet = false
    @State var searchedLocation: CLLocation
    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: Double(AppUtility.shared.latitude ?? "") ?? 0.0,
            longitude: Double(AppUtility.shared.longitude ?? "") ?? 0.0
        ),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    @State private var searchText: String = ""

    var filteredLocations: [ImageData] {
        if searchText.isEmpty {
            return locations
        } else {
            return locations.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack {
//            TextField("Search", text: $searchText, onCommit: {
//                updateMapRegion()
//            })
//            .padding(.horizontal)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .onTapGesture {
//                showingSheet.toggle()
//            }
//            .sheet(isPresented: $showingSheet) {
//                SearchLocationsScreen()
//            }
            
            
            HStack {
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Text("Search Locations")
                        .padding(4)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                        )
                        .foregroundColor(Color.blue)
                        .padding(.horizontal)
                        .sheet(isPresented: $showingSheet) {
                            SearchLocationsScreen(location: $searchedLocation)
                        }
                        .onChange(of: searchedLocation) {
                           
                            mapRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(
                                    latitude: searchedLocation.coordinate.latitude,
                                    longitude: searchedLocation.coordinate.longitude
                                ),
                                span: mapRegion.span
                            )
                        }
                }
                
                Button {
                    searchedLocation = CLLocation(latitude: Double(AppUtility.shared.latitude ?? "0.0") ?? 0,
                                                  longitude: Double(AppUtility.shared.longitude ?? "0.0") ?? 0)
                } label: {
                    Image(systemName: "location.circle.fill")
                        .font(.title)
                        .padding(.trailing)
                }
            }
            
            
            
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: filteredLocations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                )) {
                    NavigationLink(destination: DetailsScreen(imageData: location)) {
                        VStack {
                            Image(systemName: "map.fill")
                                .font(.largeTitle)
                                .frame(width: 15, height: 15)
                                .foregroundColor(.blue)
                                .padding()

                            Text(location.title).foregroundColor(Color.black)
                                .bold()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }

    private func updateMapRegion() {
        if let firstLocation = filteredLocations.first {
            mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: firstLocation.latitude,
                    longitude: firstLocation.longitude
                ),
                span: mapRegion.span
            )
        }
    }
}


struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(configuration.isPressed ? Color.gray : Color.blue, lineWidth: 2)
            )
            .foregroundColor(configuration.isPressed ? Color.gray : Color.blue)
            .animation(.easeInOut)
    }
}
