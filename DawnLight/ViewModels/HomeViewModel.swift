//
//  MainViewModel.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI
import CoreLocation

class HomeViewModel: ObservableObject {
    init() {
        if CLLocationManager.locationServicesEnabled() && usingGPS {
            location = LocationManager(listener: self)
        }
    }
    
    @Published private var model = SettingsModel()
    @Published var alarmSet = false
    @Published var isLoading = false
    @Published var sunriseAsDate: Date?
    
    var buzzDate = Date()
    var backupBuzz: Date {
        get {
            model.backupBuzz ?? Date()
        }
        set {
            model.backupBuzz = newValue
        }
    }
    var volume: Float {
        get {
            model.volume
        }
        set {
            model.volume = newValue
        }
    }
    var usingGPS: Bool {
        get {
            model.usingGPS
        }
        set {
            model.usingGPS = newValue
        }
    }
    var alarm: Alarm {
        get {
            model.alarm
        }
        set {
            model.alarm = newValue
        }
    }
    
    let weatherAPI = WeatherAPI()
    var location: LocationManager?
    var sunriseTime: String? {
        if let sunriseDate = sunriseAsDate {
            let stringDateFormatter = DateFormatter()
            stringDateFormatter.dateFormat = "hh:mm"
            return stringDateFormatter.string(from: sunriseDate)
        }
        return nil
    }
    
    //MARK: - Intents
    func loadWeatherData() {
        if sunriseAsDate == nil && isLoading == false {
            if let latitude = self.location?.lastLocation?.coordinate.latitude, let longitude = self.location?.lastLocation?.coordinate.longitude {
                isLoading = true
                try? self.weatherAPI.getWeather(lat: latitude, lon: longitude) { data in
                    guard let data = data else { return }
                    self.formatData(data)
                    self.isLoading = false
                }
            }
        }
        return
    }
    
    private func formatData(_ data: SunriseData){
        model.sunrise = data.results.sunrise
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        if let date = dateFormatter.date(from: data.results.sunrise) {
            sunriseAsDate = date
            buzzDate = date
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(model)
        
        UserDefaults.standard.setValue(data, forKey: "HomeModel")
    }
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "HomeModel") else {
            fatalError("Can not load Settings")
        }
        let decoder = JSONDecoder()
        let savedData = try? decoder.decode(SettingsModel.self, from: data)
        if let data = savedData {
            model = data
        }
    }
}
