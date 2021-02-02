import Foundation
import Combine
import CoreLocation

class LocationViewModel: NSObject, ObservableObject{
    
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    
    @Published var placeName: CLPlacemark?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    public func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                                -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
                                            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { place,_  in
            self.placeName = place?.first
        })
    }
}
