////
////  LocationManager.swift
////  SmartTravel 1
////
////  Created by Invotyx Mac on 06/11/2023.
////
//
//import Foundation
//import CoreLocation
//import Combine
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//
//    private let locationManager = CLLocationManager()
//    @Published var locationStatus: CLAuthorizationStatus?
//    @Published var lastLocation: CLLocation?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//   
//    
//    var statusString: String {
//        guard let status = locationStatus else {
//            return "unknown"
//        }
//        
//        switch status {
//        case .notDetermined: return "notDetermined"
//        case .authorizedWhenInUse: return "authorizedWhenInUse"
//        case .authorizedAlways: return "authorizedAlways"
//        case .restricted: return "restricted"
//        case .denied: return "denied"
//        default: return "unknown"
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        locationStatus = status
//        print(#function, statusString)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        lastLocation = location
//        print(#function, location)
//    }
//}


import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var city: String = "Unknown"
    @Published var country: String = "Unknown"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocode error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                self.city = placemark.locality ?? "Unknown"
                self.country = placemark.country ?? "Unknown"
            }
        }
    }
}
