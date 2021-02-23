import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    init(listener: HomeViewModel) {
        self.listener = listener
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.checkLocationAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }
    var listener: HomeViewModel
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private let locationManager = CLLocationManager()
    
    func checkLocationAuthorization(){
        if locationStatus == .notDetermined || locationStatus == nil {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        listener.loadWeatherData()
    }
}
