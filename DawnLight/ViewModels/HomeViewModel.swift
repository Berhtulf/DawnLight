//
//  MainViewModel.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var alarmSet = false
    
    @Published var model = HomeModel()
    
    @Published var isLoading = false
    @Published var sunriseAsDate: Date?
    
    let weatherAPI = WeatherAPI()
    
    var location = LocationManager()
    var sunriseTime: String? {
        if let sunriseDate = sunriseAsDate {
            let stringDateFormatter = DateFormatter()
            stringDateFormatter.dateFormat = "hh:mm"
            return stringDateFormatter.string(from: sunriseDate)
        }
        return nil
    }
    
    var selectedTab: Int {
        get {
            model.selectedTab
        }
        set {
            model.selectedTab = newValue
        }
    }
    var buzzDate = Date()
    
    
    //MARK: - Intents
    func loadWeatherData() {
        if sunriseAsDate == nil {
            isLoading = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if let latitude = self.location.lastLocation?.coordinate.latitude, let longitude = self.location.lastLocation?.coordinate.longitude {
                    try? self.weatherAPI.getWeather(lat: latitude, lon: longitude) { data in
                        guard let data = data else { return }
                        self.setData(data)
                        self.isLoading = false
                        timer.invalidate()
                    }
                }
            }
        }
        return
    }
    
    func setData(_ data: WeatherData) {
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "yyyy-MM-dd"
        let dateText = stringDateFormatter.string(from: Date().add(days: 1))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = NSTimeZone.local
        let date = dateFormatter.date(from: dateText + " " + data.astronomy.astro.sunrise)
        
        sunriseAsDate = date
        self.buzzDate = date ?? Date()
        model.sunrise = data.astronomy.astro.sunrise
    }
}
