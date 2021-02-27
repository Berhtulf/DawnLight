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
        brightness = UIScreen.main.brightness
        load()
        if CLLocationManager.locationServicesEnabled() && usingGPS {
            location = LocationManager(listener: self)
        }
    }
    deinit {
        save()
    }
    
    @Published private(set) var model = SettingsModel()
    @Published var alarmSet = false
    @Published var isShowingBlackScreen = false
    @Published var isLoading = false
    @Published var sunriseAsDate: Date?
    
    var alarmController = AlarmController()
    var buzzDate = Date()
    var backupBuzz: Date {
        get {
            model.backupBuzz ?? Date()
        }
        set {
            model.backupBuzz = newValue
            setNewBuzzDate()
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
            if newValue {
                if location?.locationStatus == .denied {
                    showDeniedWarning()
                    model.usingGPS = false
                    return
                }
                location = LocationManager(listener: self)
                setNewBuzzDate()
            }
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
            return DateFormatter.localizedString(from: sunriseDate, dateStyle: .none, timeStyle: .short)
        }
        return nil
    }
    var buzzTime: String {
        return DateFormatter.localizedString(from: buzzDate, dateStyle: .none, timeStyle: .short)
    }
    
    private func formatData(_ data: SunriseData){
        model.sunrise = data.results.sunrise
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        if let date = dateFormatter.date(from: data.results.sunrise) {
            sunriseAsDate = date
            buzzDate = min(backupBuzz, date)
        }
    }
    
    //MARK: - Intents
    @Published var isShowingLocationWarning = false
    func showDeniedWarning() {
        isShowingLocationWarning = true
    }
    func scheduleAlarm() {
        isShowingBlackScreen = false
        refreshTimer?.invalidate()
        if usingGPS{
            guard let sunrise = sunriseAsDate else { return }
            buzzDate = sunrise
        }
        updateBuzzTimes()
        if (usingGPS){
            buzzDate = min(buzzDate, backupBuzz)
        }
        alarmController.createAVPlayer(sound: alarm.systemName)
        alarmController.play(volume: volume, delay: buzzDate.timeIntervalSinceNow)
        withAnimation{
            alarmSet = true
        }
        startScreenTimer()
        print("Alarm set to \(buzzDate), volume: \(volume), alarm: \(alarm.systemName)")
    }
    func cancelAlarm() {
        withAnimation{
            alarmController.cancelAlarm()
            alarmSet = false
        }
    }
    
    private var refreshTimer: Timer?
    func startScreenTimer() {
        self.refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.refreshTimer = timer
            if (self.alarmSet) {
                self.showBlackScreen()
            }else{
                self.refreshTimer?.invalidate()
            }
        }
    }
    var brightness: CGFloat
    func showBlackScreen() {
        withAnimation(.easeInOut(duration: 2)){
            brightness = UIScreen.main.brightness
            isShowingBlackScreen = true
            refreshTimer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                UIScreen.main.brightness = CGFloat(0)
            }
        }
    }
    func hideBlackScreen() {
        withAnimation(.easeInOut(duration: 1)){
            UIScreen.main.brightness = CGFloat(brightness)
            isShowingBlackScreen = false
        }
    }
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
    func updateBuzzTimes() {
        if backupBuzz.timeIntervalSinceNow < 0 {
            backupBuzz.addTimeInterval(86400)
        }
        if backupBuzz.timeIntervalSinceNow > 86400 {
            backupBuzz.addTimeInterval(-86400)
        }
        if buzzDate.timeIntervalSinceNow > 86400 {
            buzzDate.addTimeInterval(-86400)
        }
        if buzzDate.timeIntervalSinceNow < 0 {
            buzzDate.addTimeInterval(86400)
        }
    }
    func setNewBuzzDate() {
        buzzDate = sunriseAsDate ?? Date()
        updateBuzzTimes()
        buzzDate = min(buzzDate, backupBuzz)
    }
    
    func save() {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(model)
        
        UserDefaults.standard.setValue(data, forKey: "HomeModel")
        print("UserDefaults SAVED")
    }
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "HomeModel") else {
            return
        }
        let decoder = JSONDecoder()
        let savedData = try? decoder.decode(SettingsModel.self, from: data)
        if let data = savedData {
            model = data
            print("UserDefaults LOADED")
        }
    }
}
