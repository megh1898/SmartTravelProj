import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var city: String = "Unknown"
    @Published var country: String = "Unknown"
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
                
                if let city = placemark.name {
                    self.city = city
                    AppUtility.shared.city = city
                }
                
                if let country = placemark.country {
                    self.country = country
                    AppUtility.shared.country = country
                }
                
                self.location = placemark.location

                if let lat = placemark.location?.coordinate.latitude {
                    AppUtility.shared.latitude = "\(lat)"
                }
                
                if let long = placemark.location?.coordinate.longitude {
                    AppUtility.shared.longitude = "\(long)"
                }

                self.locationManager.stopUpdatingLocation()
            }
        }
    }
}
